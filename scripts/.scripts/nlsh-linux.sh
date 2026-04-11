#!/bin/zsh
# =============================================================================
#  llm-agent -- Natural language → shell command, powered by Ollama
#
#  INSTALL
#  -------
#  1. Install Ollama:   https://ollama.com
#  2. Pull model:       ollama pull mistral
#  3. Make executable:  chmod +x llm-agent.sh
#  4. Alias it:         echo 'alias ask="~/llm-agent.sh"' >> ~/.bashrc
#
#  USAGE
#  -----
#  One-shot:       ask "find what's eating disk space"
#  Interactive:    ask
#  Custom model:   MODEL=gemma3:4b ask "show open ports"
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
#  Responses saved to ~/.scripts/llm_agent_cache.jsonl
#  Use 'fask' to fuzzy-search history with fzf + preview
# =============================================================================

MODEL="${MODEL:-mistral}"
CACHE_FILE="$HOME/.scripts/nlsh-cache.jsonl"

# HP 450 G3: i5-6200U, 2 cores/4 threads — leave 1 thread for the OS
export OLLAMA_NUM_THREAD=3

# ── colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
YLW='\033[0;33m'
GRN='\033[0;32m'
DIM='\033[2m'
BLD='\033[1m'
RST='\033[0m'

# ── system info ───────────────────────────────────────────────────────────────
SYSINFO="$(uname -s) $(uname -r), shell: $(basename "$SHELL"), pkg: apt"

# ── logging ───────────────────────────────────────────────────────────────────
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

  read -rp "Run? (y/n): " confirm
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
