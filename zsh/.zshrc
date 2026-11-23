# Shared zsh config for Linux (Debian) and macOS. Kept simple: no framework, no theme.

# --- PATH ---
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)" # macOS Homebrew
typeset -U path # dedupe
path=(
  ~/.local/bin                  # claude, uv, yazi, ...
  /opt/nvim-linux-x86_64/bin(N) # neovim tarball on Linux ((N): skip if missing)
  $path
)

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space hist_reduce_blanks

# --- Options ---
setopt auto_cd interactive_comments no_beep

# --- Completion ---
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case-insensitive

# --- Vi mode ---
bindkey -v
KEYTIMEOUT=1 # fast <Esc>
bindkey '^?' backward-delete-char # backspace past insert point
bindkey '^R' history-incremental-search-backward # overridden by fzf below if present
# Cursor shape per mode: block in normal, beam in insert
zle-keymap-select zle-line-init() {
  [[ $KEYMAP == vicmd ]] && printf '\e[2 q' || printf '\e[6 q'
}
zle -N zle-keymap-select
zle -N zle-line-init

# --- Prompt: dir, git branch, red on error ---
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats ' %F{magenta}(%b)%f'
precmd() { vcs_info }
setopt prompt_subst
PROMPT='%F{blue}%~%f${vcs_info_msg_0_} %(?.%F{green}.%F{red})❯%f '

# --- Aliases ---
(( $+commands[batcat] && ! $+commands[bat] )) && alias bat=batcat # Debian names it batcat
alias vim=nvim

# --- Tools ---
(( $+commands[fzf] )) && source <(fzf --zsh)       # Ctrl-R history, Ctrl-T files
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)" # z <dir>

# --- Plugins (apt on Debian, Homebrew on macOS); syntax-highlighting must be last ---
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  for dir in /usr/share/$plugin ${HOMEBREW_PREFIX:-/opt/homebrew}/share/$plugin; do
    [[ -r $dir/$plugin.zsh ]] && source $dir/$plugin.zsh && break
  done
done
unset plugin dir
