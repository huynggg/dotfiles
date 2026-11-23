#!/usr/bin/env bash
# Symlink dotfiles into place. Safe to re-run.
# Existing real files/dirs at a target are moved to <target>.bak.<timestamp> first.
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# repo path -> link target
LINKS=(
  "nvim:$HOME/.config/nvim"
  "tmux/tmux.conf:$HOME/.config/tmux/tmux.conf"
  "sesh:$HOME/.config/sesh"
  "claude/CLAUDE.md:$HOME/.claude/CLAUDE.md"
  "claude/settings.json:$HOME/.claude/settings.json"
)

# macOS only
if [[ "$(uname -s)" == "Darwin" ]]; then
  LINKS+=(
    "zsh/.zshrc:$HOME/.zshrc"
    "aerospace/aerospace.toml:$HOME/.aerospace.toml"
  )
fi

link() {
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -L "$dst" ]]; then
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    mv "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"
    echo "backed up $dst"
  fi
  ln -s "$src" "$dst"
  echo "$dst -> $src"
}

for entry in "${LINKS[@]}"; do
  link "${entry%%:*}" "${entry#*:}"
done
