#!/bin/zsh
# =============================================================================
#  llm-agent -- Natural language → shell command, powered by Ollama
#
#  INSTALL
#  -------
#  1. Install Ollama:   https://ollama.com
#  2. Pull model:       ollama pull mistral
#  3. Make executable:  chmod +x llm-agent.sh
#  4. Alias it:  echo 'alias nlsh="~/.scripts/nlsh-linux.sh"' >> ~/.zshrc
#
#  USAGE
#  -----
#  One-shot:       nlsh "find what's eating disk space"
#  Interactive:    nlsh
#  Custom model:   MODEL=gemma3:4b nlsh "show open ports"
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
#  Regex blocklist catches dangerous patterns before execution.
#  Nothing runs without y/n confirmation.
#
#  CACHE
#  -----
#  Responses saved to ~/.scripts/nlsh-cache.jsonl
#  Use 'fsh' to fuzzy-search history with fzf + preview
# =============================================================================

# --- config ---
MODEL="${MODEL:-mistral}"
CACHE_FILE="$HOME/.scripts/nlsh-cache.jsonl"

export OLLAMA_NUM_THREAD=3

# ── colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
YLW='\033[0;33m'
GRN='\033[0;32m'
DIM='\033[2m'
BLD='\033[1m'
RST='\033[0m'

# ── system info ───────────────────────────────────────────────────────────────
SYSINFO="Linux, shell: $SHELL, pkg: apt"

# ── logging ───────────────────────────────────────────────────────────────────
mkdir -p "$(dirname "$CACHE_FILE")"
log_to_cache() {
  local prompt="$1"
  local full_response="$2"
  local cmd
  cmd=$(echo "$full_response" | head -n 1)
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
    'rm[[:space:]]+-[rRfF].*/|mkfs|dd[[:space:]]+if=.*of=/dev|> /dev/|chmod[[:space:]]+-R[[:space:]]+777[[:space:]]+/|shred[[:space:]]+/dev/'
}

# ── prompt ────────────────────────────────────────────────────────────────────
build_prompt() {
  cat <<EOF
System: $SYSINFO
Rules:
1. First line: ONE shell command only. No markdown. No preamble.
2. Lines 2+: each flag as ie. "-{flag_character}: meaning"
3. Last line: "EFFECT: one sentence"
4. Use common Linux commands only. Prefer simple over complex.

Request: $1
EOF
}

# ── model ─────────────────────────────────────────────────────────────────────
call_model() {
  build_prompt "$1" | ollama run "$MODEL" | col -b
}

# ── execution ─────────────────────────────────────────────────────────────────
run_cmd() {
  local response="$1"
  local cmd
  cmd=$(echo "$response" | head -1)

  echo
  echo -e "$response"
  echo

  if is_dangerous "$cmd"; then
    echo -e "${RED}${BLD}⛔  Blocked — dangerous pattern matched${RST}"
    return
  fi
  printf "Run? (y/n): "
  read -r confirm
  if [[ "$confirm" == "y" ]]; then
    echo -e "${DIM}running: $cmd${RST}"
    eval "$cmd"
  else
    echo -e "${DIM}cancelled${RST}"
  fi
}

# ── check ollama ──────────────────────────────────────────────────────────────
if ! ollama list &>/dev/null; then
  echo -e "${RED}Ollama not running. Start with: ollama serve${RST}"
  exit 1
fi

# ── main ──────────────────────────────────────────────────────────────────────
if [[ -n "$1" ]]; then
  response=$(call_model "$1")
  log_to_cache "$1" "$response"
  run_cmd "$response"
else
  echo -e "${BLD}llm-agent${RST} ${DIM}(${MODEL})${RST} — type 'exit' to quit"
  echo
  while true; do
    printf "${GRN}>>${RST} "
    read -r input
    [[ "$input" == "exit" ]] && break
    [[ -z "$input" ]] && continue
    response=$(call_model "$input")
    log_to_cache "$input" "$response"
    run_cmd "$response"
  done
fi
