#!/bin/zsh
# =============================================================================
#  llm-agent -- Natural language → shell command, powered by Ollama
#
#  INSTALL
#  -------
#  1. Install Ollama:   https://ollama.com
#  2. Pull model:       ollama pull bjoernb/gemma4-e4b-think:latest
#  3. Make executable:  chmod +x llm-agent.sh
#  4. Alias it:         echo 'alias ask="~/.scripts/llm-agent.sh"' >> ~/.zshrc
#
#  USAGE
#  -----
#  One-shot:       ask "find what's eating disk space"
#  With mode:      ask --mode=net "show open ports"
#  Interactive:    ask
#  Custom model:   MODEL=gemma3:12b ask "show cpu temp"
#
#  MODES
#  -----
#  --mode=disk    Disk & filesystem (du, df, diskutil, find)
#  --mode=net     Network diagnostics (ifconfig, netstat, nmap, dig)
#  --mode=proc    Processes & services (ps, lsof, launchctl)
#  --mode=pkg     Homebrew only (brew install/upgrade/cleanup)
#  (default)      General-purpose macOS commands
#
#  OUTPUT FORMAT
#  -------------
#  Every response follows this structure:
#    <command>
#    -f: what this flag does
#    EFFECT: one plain-English sentence
#
#  SAFETY
#  ------
#  Two-tier guard — nothing runs without confirmation:
#    [DESTRUCTIVE] prefix  → model self-flags risky commands
#                            requires typing "yes" in full
#    Regex blocklist       → hard-blocks patterns the model may miss
#                            (rm -rf /, dd if=, diskutil eraseDisk, etc.)
#
#  CACHE
#  -----
#  Responses saved to ~/.scripts/llm_agent_cache.jsonl
#  Use 'fask' to fuzzy-search history with fzf + preview
# =============================================================================

# ── configuration ─────────────────────────────────────────────────────────────
MODEL="${MODEL:-bjoernb/gemma4-e4b-think:latest}"
CACHE_FILE="$HOME/.scripts/nlsh-cache.jsonl"

# ── colours ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
YLW='\033[0;33m'
GRN='\033[0;32m'
DIM='\033[2m'
BLD='\033[1m'
RST='\033[0m'

# ── system context ────────────────────────────────────────────────────────────
MACOS_VER=$(sw_vers -productVersion)
CHIP=$( [[ $(uname -m) == "arm64" ]] && echo "Apple Silicon" || echo "Intel" )
PKG_MGR=$(command -v brew &>/dev/null && echo "homebrew" || echo "none")
RAM_GB=$(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 ))
SYSINFO="macOS ${MACOS_VER} (${CHIP}), shell: zsh, pkg: ${PKG_MGR}, RAM: ${RAM_GB}GB"

# ── mode definitions ──────────────────────────────────────────────────────────
typeset -A MODES
MODES[disk]="macOS disk/filesystem commands. Use: du, df, diskutil, ncdu, find -size. No deletion."
MODES[net]="macOS network commands. Use: ifconfig, networksetup, netstat, lsof -i, nmap, ping, dig, curl."
MODES[proc]="macOS process/service commands. Use: ps, top, htop, lsof, kill, launchctl, powermetrics."
MODES[pkg]="Homebrew only. Use: brew install/upgrade/list/info/search/cleanup/doctor."

# ── logging ───────────────────────────────────────────────────────────────────
log_to_cache() {
  local prompt="$1"
  local full_response="$2"
  local cmd=$(echo "$full_response" | head -n 1)
  command -v jq &>/dev/null || return
  jq -cn \
    --arg p "$prompt" \
    --arg c "$cmd" \
    --arg r "$full_response" \
    --arg t "$(date +'%Y-%m-%d %H:%M:%S')" \
    '{timestamp: $t, prompt: $p, command: $c, response: $r}' >> "$CACHE_FILE"
}

# ── safety ────────────────────────────────────────────────────────────────────
is_dangerous() {
  echo "$1" | grep -qiE \
    'rm[[:space:]]+-[rRfF]{1,3}[[:space:]]+/|diskutil[[:space:]]+(eraseDisk|zeroDisk|secureerase)|dd[[:space:]]+if=|chmod[[:space:]]+-R[[:space:]]+777[[:space:]]+/|mkfs\.|> /dev/[sh]d[a-z]|shred[[:space:]]+/dev/'
}

check_tool_available() {
  local cmd="${1#\[DESTRUCTIVE\] }"
  local binary=$(echo "$cmd" | awk '{print $1}' | xargs basename 2>/dev/null)
  [[ -z "$binary" ]] && return 0
  command -v "$binary" &>/dev/null
}

# ── prompt & model ────────────────────────────────────────────────────────────
build_prompt() {
  cat <<PROMPT
System: ${SYSINFO}
Mode: ${MODE_CTX}

Rules:
1. Line 1: ONE shell command only. No markdown. No preamble.
2. Lines 2+: each flag as "-x: meaning"
3. Last line: "EFFECT: one sentence"
4. If dangerous: start line 1 with [DESTRUCTIVE]

Request: $1
PROMPT
}

call_model() {
  build_prompt "$1" | ollama run "$MODEL" --think=false | col -b
}

# ── execution ─────────────────────────────────────────────────────────────────
run_response() {
  local response="$1"
  local first_line=$(echo "$response" | head -1)

  echo

  if ! check_tool_available "$first_line"; then
    local binary=$(echo "${first_line#\[DESTRUCTIVE\] }" | awk '{print $1}' | xargs basename 2>/dev/null)
    echo -e "${YLW}${BLD}Tool not available:${RST} ${YLW}'${binary}' is not installed.${RST}"
    return
  fi

  if echo "$first_line" | grep -q "\[DESTRUCTIVE\]"; then
    echo -e "${RED}${BLD}⚠  DESTRUCTIVE OPERATION${RST}"
    echo -e "${YLW}${response}${RST}\n"
    printf "Type ${BLD}yes${RST} to run: "
    read -r CONFIRM
    [[ "$CONFIRM" == "yes" ]] && eval "${first_line#\[DESTRUCTIVE\] }" || echo -e "${DIM}cancelled.${RST}"
  elif is_dangerous "$response"; then
    echo -e "${RED}${BLD}⛔  BLOCKED${RST} — dangerous pattern matched"
  else
    echo -e "${response}\n"
    printf "Run? ${DIM}(y/n)${RST}: "
    read -r CONFIRM
    [[ "$CONFIRM" == "y" ]] && eval "$first_line" || echo -e "${DIM}cancelled.${RST}"
  fi
  echo
}

# ── entry ─────────────────────────────────────────────────────────────────────
check_ollama() {
  if ! command -v ollama &>/dev/null || ! ollama list &>/dev/null; then
    echo -e "${RED}Ollama is not running.${RST}"
    exit 1
  fi
}

oneshot() {
  check_ollama
  local response=$(call_model "$1")
  log_to_cache "$1" "$response"
  run_response "$response"
}

interactive() {
  check_ollama
  echo -e "${BLD}llm-agent${RST}\n"
  while true; do
    printf "${GRN}>>${RST} "
    read -r PROMPT
    [[ "$PROMPT" == "exit" || "$PROMPT" == "quit" ]] && break
    [[ -z "$PROMPT" ]] && continue
    local response=$(call_model "$PROMPT")
    log_to_cache "$PROMPT" "$response"
    run_response "$response"
  done
}

# ── parse args ────────────────────────────────────────────────────────────────
MODE="general"
ONESHOT_PROMPT=""
for arg in "$@"; do
  [[ "$arg" == --mode=* ]] && MODE="${arg#--mode=}" || ONESHOT_PROMPT="$arg"
done
MODE_CTX="${MODES[$MODE]:-Safe macOS commands.}"

if [[ -n "$ONESHOT_PROMPT" ]]; then oneshot "$ONESHOT_PROMPT"; else interactive; fi
