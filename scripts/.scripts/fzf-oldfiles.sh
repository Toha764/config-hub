#!/bin/bash
list_oldfiles() {
    local shada_file="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/shada/main.shada"

    # (@f) splits on newlines — zsh's equivalent of mapfile -t
    local -a oldfiles
    oldfiles=("${(@f)$(nvim -u NONE --headless -i "$shada_file" \
        -c 'lua io.write(table.concat(vim.v.oldfiles, "\n") .. "\n")' \
        -c 'qa!' 2>/dev/null < /dev/null)}")

    local -a valid_files=()
    local file
    for file in "${oldfiles[@]}"; do
        [[ -f "$file" ]] && valid_files+=("$file")
    done

    local -a files
    files=("${(@f)$(printf "%s\n" "${valid_files[@]}" |
        grep -v '^\[' |
        fzf --multi \
            --height=80% \
            --layout=reverse \
            --border \
            --padding=1 \
            --margin=1 \
            --prompt=" Select files ❯ " \
            --pointer="▶" \
            --marker="✓" \
            --separator="─" \
            --color=bg+:#1e1e2e,bg:#181825,spinner:#f5e0dc,hl:#f38ba8 \
            --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
            --color=marker:#a6e3a1,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
            --preview 'bat --style=numbers --color=always --line-range=:300 {} 2>/dev/null || echo "No preview available"' \
            --preview-window=right:60%:wrap \
            --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'
    )}")

    # Remove the empty-string element (@f) leaves on no-selection
    files=("${(@)files[@]:#}")   # strips empty strings from array

    if [[ ${#files[@]} -gt 0 ]]; then
        local first_dir
        first_dir=$(dirname "${files[1]}")  # zsh: 1-indexed, not 0
        cd "$first_dir" || { echo "Failed to cd to $first_dir"; return 1; }
        nvim "${files[@]}"
    fi
}
list_oldfiles "$@"
