### Oh My Zsh ###
ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $HOME/.oh-my-zsh/oh-my-zsh.sh

# ~Nyaan (IMPORTANT! shell session won't open without it!, obviously :3 )
printf '\e[35m
                    /\_/\\
                   ( o.o )
                    > ^ <
\e[0m
'

### Some vanilla zsh-config stolen from Kali Linux ###
# --- Navigation ---
setopt autocd              # cd into a directory just by typing its name
WORDCHARS='_- '           # treat _ and - as word separators (better movement/editing)

# --- Auto Completion ---
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

zstyle ':completion:*' menu select                          # interactive menu on TAB
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive matching
zstyle ':completion:*' auto-description 'specify: %d'       # better descriptions
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more%s

# --- History Improvements ---
setopt HIST_IGNORE_ALL_DUPS      # remove older duplicates
setopt SHARE_HISTORY            # share history across sessions
setopt hist_ignore_space        # don't save commands starting with space
setopt hist_verify              # show expanded history before executing
setopt hist_expire_dups_first   # clean duplicates first when trimming

setopt CORRECT                  # auto-correct minor typos
setopt COMPLETE_IN_WORD         # allow completion inside words
setopt magicequalsubst          # expand paths in assignments (VAR=~/file)
setopt nonomatch                # don't error if glob doesn't match

# --- Keybindings (works w/ vi + emacs) ---
bindkey '^[[1;5C' forward-word   # Ctrl + →
bindkey '^[[1;5D' backward-word  # Ctrl + ←
bindkey '^U' backward-kill-line  # Ctrl + U delete line

NEWLINE_BEFORE_PROMPT=yes        # add spacing before each prompt

# --- Better man/help page colors ---
export LESS_TERMCAP_md=$'\E[1;36m'  # bold text
export LESS_TERMCAP_us=$'\E[1;32m'  # underline text

# ====================================================================
# From this point on, highly customized and requires dependencies
# git cli, fzf, zoxide, tmux, eza, bat, neovim, pet, fd, rg
# ====================================================================

### FZF & Navigation Tools ###
source <(fzf --zsh)
eval "$(zoxide init zsh)"
export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border top'

### Editor & Mode ###
set -o vi
export EDITOR="nvim"
export VISUAL="nvim"

### qol alias ###
alias src='source ~/.zshrc'      # reload config
alias rc='nvim $HOME/.zshrc'    # edit config

# --- quick commands ---
alias c="clear"
alias nv="nvim"
alias yz="yazi"

# --- SUPER CUSTOM COMMANDS ---
alias cat="bat"
alias ls="eza --no-filesize --long --color=always --icons=always --no-user"
alias tx="tmux attach 2>/dev/null || tmux new-session -s main"

### Fuzzy Obessesion ###
alias fnv="nvim \$(fzf --preview 'bat --color=always {}')"                      # fuzzy open file

### Git Shortcuts ###
alias ga="git add ."
alias gs="git status -s"
alias gc='git commit -m'
alias gp='git push origin'
alias gl='git log --oneline --graph --all'
alias gcreate='gh repo create --private --source=. --remote=origin'

# Added by Antigravity IDE
export PATH="/Users/toha/.antigravity-ide/antigravity-ide/bin:$PATH"
export CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1
export ANTHROPIC_BASE_URL="http://localhost:20128"
export ANTHROPIC_AUTH_TOKEN="sk-7cb0adcfa88f7f94-8fff4a-280f6bdd"

# Pet
export FZF_CTRL_R_OPTS="
  --reverse
  --cycle
  --info=right
  --color header:italic
  --header 'alt+s (pet new)'
  --preview 'echo {}' --preview-window down:3:hidden:wrap
  --bind '?:toggle-preview'
  --bind 'alt-s:execute(pet new --tag {2..})+abort'"

# ========================================
# replaces buffer — existing ^S
function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER" </dev/tty)
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
bindkey '^s' pet-select

# appends to buffer with pipe — new ^p
function pet-pipe() {
  local snippet
  snippet=$(pet search --query "" </dev/tty)
  [ -n "$snippet" ] && LBUFFER="${LBUFFER} | ${snippet}"
  zle redisplay
}
zle -N pet-pipe
bindkey '^p' pet-pipe

function _pet_move_cursor_to_next_parameter() {
  local match default match_len default_len parameter_offset
  match="$(echo "$BUFFER" | perl -nle 'print $& if /<.*?>/')"
  if [ -n "$match" ]; then
    setopt local_options no_glob_subst
    default="$(echo "$match" | perl -nle 'print $& if /(?<==).*(?=>)/')"
    match_len=${#match}
    default_len=${#default}
    parameter_offset=${#BUFFER%%$match*}
    CURSOR="$((parameter_offset + default_len))"
    BUFFER="${BUFFER[1,$parameter_offset]}${default}${BUFFER[$parameter_offset+$match_len+1,-1]}"
  fi
}
zle -N _pet_move_cursor_to_next_parameter
bindkey '^n' _pet_move_cursor_to_next_parameter

stty -ixon  # at the bottom
# =======================================
