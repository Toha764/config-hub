#!/usr/bin/env zsh

cache="$HOME/.scripts/nlsh-cache.jsonl"

[[ ! -f "$cache" ]] && echo "No history found at $cache" && return

selected=$(jq -rc 'select(.command and .prompt) | [.prompt, .command] | @tsv' "$cache" \
  | tac \
  | fzf --delimiter='\t' \
        --with-nth=1 \
        --height=80% \
        --layout=reverse \
        --border \
        --padding=1 \
        --margin=1 \
        --prompt=" Search commands ❯ " \
        --pointer="▶" \
        --marker="✓" \
        --separator="─" \
        --header="Natural Shell History" \
        --color=bg+:#1e1e2e,bg:#181825,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#a6e3a1,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
        --preview='echo {2}' \
        --preview-window=right:50%:wrap \
        --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down')

[[ -z "$selected" ]] && return

cmd=$(echo "$selected" | cut -f2)
print -z "$cmd"
