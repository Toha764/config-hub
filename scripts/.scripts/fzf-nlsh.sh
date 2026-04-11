#!/usr/bin/env zsh

cache="$HOME/.scripts/nlsh_cache.jsonl"

[[ ! -f "$cache" ]] && echo "No history found at $cache" && exit 1

selected=$(jq -rc 'select(.command and .prompt) | [.prompt, .command] | @tsv' "$cache" \
  | tac \
  | fzf --delimiter='\t' \
        --with-nth=1 \
        --height=40% --layout=reverse --border \
        --header="AI Memory" \
        --preview='echo {2}' \
        --preview-window=right:40%:wrap)

[[ -z "$selected" ]] && exit 0

cmd=$(echo "$selected" | cut -f2)
print -z "$cmd"
