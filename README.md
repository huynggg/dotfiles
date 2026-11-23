# dotfiles

## Contents

| Folder | Linked to | Where |
|---|---|---|
| `nvim/` | `~/.config/nvim` | all |
| `tmux/tmux.conf` | `~/.config/tmux/tmux.conf` | all |
| `sesh/` | `~/.config/sesh` | all |
| `claude/CLAUDE.md`, `claude/settings.json` | `~/.claude/` | all |
| `git/.gitconfig` | `~/.gitconfig` | all |
| `lazygit/config.yml` | `~/.config/lazygit/` (Linux), `~/Library/Application Support/lazygit/` (macOS) | all |
| `zsh/.zshrc` | `~/.zshrc` | macOS |
| `aerospace/aerospace.toml` | `~/.aerospace.toml` | macOS |

## Install

```sh
git clone https://github.com/huynggg/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Existing files at a target are moved to `<target>.bak.<timestamp>`.
Re-running is safe.

Neovim: requires 0.12+.
Plugins install on first start.
Then run `:InstallTools` once for LSP servers, formatters and treesitter parsers.

## Adding a new config

1. Move the config into its own folder: `mv ~/.config/foo ~/dotfiles/foo`.
2. Add `"foo:$HOME/.config/foo"` to `LINKS` in `install.sh` (in the macOS or Linux block if OS-specific).
3. Run `./install.sh`, add a row to the table above, commit.

## Rules

- One folder per tool, named after the tool.
- Every link is declared in `install.sh`; nothing is linked by hand.
- Link whole directories when the tool owns the directory, single files otherwise.
- Never commit secrets, tokens or machine-local state (history, caches).
- Commit lockfiles (e.g. `nvim/nvim-pack-lock.json`).
