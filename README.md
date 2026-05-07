# dotfiles

[![macOS](https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Neovim](https://img.shields.io/badge/Neovim-57A143?logo=neovim&logoColor=white)](https://neovim.io/)
[![tmux](https://img.shields.io/badge/tmux-1BB91F?logo=tmux&logoColor=white)](https://github.com/tmux/tmux)
[![kitty](https://img.shields.io/badge/kitty-000000?logo=gnome-terminal&logoColor=white)](https://sw.kovidgoyal.net/kitty/)
[![zsh](https://img.shields.io/badge/zsh-F15A24?logo=gnubash&logoColor=white)](https://www.zsh.org/)
[![Homebrew](https://img.shields.io/badge/Homebrew-FBB040?logo=homebrew&logoColor=black)](https://brew.sh/)

Personal macOS development environment — terminals, shell, editor, window manager, and AI tooling — kept under version control and wired in via symlinks.

## Overview

This repo is the source of truth for the configs in `~/.config` and `~/`.
Each top-level directory or dotfile is symlinked into its expected location by
[`install.sh`](install.sh), so editing files here changes the live environment
on the next reload.

The Neovim config is the biggest piece — a from-scratch setup that grew out of a LazyVim distro but no longer depends on it (every plugin spec, keymap, and option is owned in this repo). See [`nvim/lua/config/keymaps.lua`](nvim/lua/config/keymaps.lua) for the keymap mental model documented at the top of the file.

## What's inside

| Path | Purpose |
|---|---|
| [`nvim/`](nvim/) | Neovim config (~30 plugin specs). Pickers via snacks.nvim, completion via blink.cmp, treesitter v1 main-branch, LSP via nvim-lspconfig + mason |
| [`.tmux.conf`](.tmux.conf) | tmux: prefix `C-s`, vim-tmux-navigator integration, true-color, kitty graphics passthrough, focus-events for nvim's autoreload |
| [`kitty.conf`](kitty.conf) | kitty terminal: FiraCode Nerd Font, blurred background, cursor trail, auto-attach to tmux on launch |
| [`current-theme.conf`](current-theme.conf) | active kitty colorscheme |
| [`.zshrc`](.zshrc) | zsh + oh-my-zsh + powerlevel10k prompt |
| [`.p10k.zsh`](.p10k.zsh) | powerlevel10k prompt config |
| [`.aerospace.toml`](.aerospace.toml) | AeroSpace tiling window manager |
| [`yazi/`](yazi/) | yazi file manager config |
| [`opencode/`](opencode/) | opencode AI agent skills tree |
| [`eligere/`](eligere/) | eligere CLI config |
| [`Brewfile`](Brewfile) | Homebrew bundle: ~27 packages + casks (nvim, tmux, fzf, ripgrep, lazygit, docker, …) |
| [`install.sh`](install.sh) | Bootstrap script: brew bundle, symlinks, oh-my-zsh themes |
| [`scripts/`](scripts/) | Helper scripts (daily-note creation, etc.) |
| [`p10k_fonts/`](p10k_fonts/) | powerlevel10k recommended font binaries |
| [`24-bit-color.sh`](24-bit-color.sh) | True-color test print |

## Getting started

### Fresh machine

```bash
# 1. Install Homebrew (skip if already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 3. Clone this repo to ~/.dotfiles
git clone https://github.com/RomanVolkov/dotfiles.git ~/.dotfiles

# 4. Run the bootstrap
cd ~/.dotfiles
bash install.sh
```

`install.sh` does three things:

1. Installs the powerlevel10k zsh theme.
2. Runs `brew bundle` against [`Brewfile`](Brewfile).
3. Creates symlinks from `~` and `~/.config` into this repo (so live edits in `~/.dotfiles` are reflected immediately).

### Adding a new tool

To track a new config under this repo, mirror the pattern used for `nvim`/`yazi`/`opencode`/`eligere`:

```bash
mv ~/.config/<tool> ~/.dotfiles/<tool>
ln -s ~/.dotfiles/<tool> ~/.config/<tool>
# then add the symlink line to install.sh and commit
```

## Highlights

**Neovim** — built from scratch on top of `lazy.nvim`. Picker is snacks.nvim
(no telescope), completion is blink.cmp, treesitter is on the v1.0+ main
branch. Keymaps follow a noun-first convention: `<leader>{f,b,s,g,c,x,w,q}*`.
`<leader>?` opens the keymap fuzzy picker; pressing `<leader>` and pausing
shows which-key. The mental model is documented at the top of
[`nvim/lua/config/keymaps.lua`](nvim/lua/config/keymaps.lua).

**tmux** — prefix is `C-s`. `prefix-r` reloads the config. Vim and tmux pane
navigation are unified via `<C-h/j/k/l>` (vim-tmux-navigator). Kitty graphics
passthrough is on for image previews; focus events are on so nvim's
`:checktime` autoreload works inside tmux.

**kitty** — auto-attaches to tmux on launch. `Cmd+F` opens an fzf overlay
over the scrollback buffer.

## Reporting issues

If something breaks on your setup or a config is missing, open a ticket at
[github.com/RomanVolkov/dotfiles/issues](https://github.com/RomanVolkov/dotfiles/issues).

## Contact

**Roman Volkov** — [github.com/RomanVolkov](https://github.com/RomanVolkov)
