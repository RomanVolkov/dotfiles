#!/bin/bash
# Idempotent dotfiles bootstrap. Safe to run repeatedly — each step
# checks first or uses overwrite-safe flags, so a re-run is a no-op
# when everything is already set up.

set -u  # error on unset vars; don't `set -e` — one missing tool
        # shouldn't abort the whole script.

DOTFILES="$HOME/.dotfiles"
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
TPM_DIR="$HOME/.tmux/plugins/tpm"

# Idempotent symlink helper. Works for files and directories. Uses -f
# (force-replace) and -n (don't follow into existing dir links — keeps
# us from accidentally creating links inside a previously-linked dir).
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
}

## ----- Pre-reqs (commented prereqs left for reference) -----
## Brew:
##   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
## Oh my zsh:
##   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## ----- powerlevel10k theme -----
# https://github.com/romkatv/powerlevel10k
if [ ! -d "$P10K_DIR" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

## ----- Homebrew packages -----
# brew bundle is itself idempotent (skips already-installed casks/formulae)
brew bundle --file="$DOTFILES/Brewfile"

## ----- Symlinks -----
# Home dir
link "$DOTFILES/.zshrc"          "$HOME/.zshrc"
link "$DOTFILES/.tmux.conf"      "$HOME/.tmux.conf"
link "$DOTFILES/.p10k.zsh"       "$HOME/.p10k.zsh"
link "$DOTFILES/.gitconfig"      "$HOME/.gitconfig"
link "$DOTFILES/.aerospace.toml" "$HOME/.aerospace.toml"

# ~/.config single-file configs
link "$DOTFILES/kitty.conf"          "$HOME/.config/kitty/kitty.conf"
link "$DOTFILES/current-theme.conf"  "$HOME/.config/kitty/current-theme.conf"
link "$DOTFILES/current-font.conf"   "$HOME/.config/kitty/current-font.conf"

# ~/.config directory configs
link "$DOTFILES/nvim"     "$HOME/.config/nvim"
link "$DOTFILES/yazi"     "$HOME/.config/yazi"
link "$DOTFILES/opencode" "$HOME/.config/opencode"
link "$DOTFILES/eligere"  "$HOME/.config/eligere"

## ----- tmux plugin manager (TPM) -----
# After this script: launch tmux and press <prefix> + I to install plugins.
if [ ! -d "$TPM_DIR" ]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

## ----- macOS tweaks -----
# Disable press-and-hold for keys (let kitty's vim-mode key repeats work).
defaults write net.kovidgoyal.kitty ApplePressAndHoldEnabled -bool false

## ----- Optional one-shot installs -----
# Go debugger — `go install` is idempotent if go is on PATH.
if command -v go >/dev/null 2>&1; then
  go install github.com/go-delve/delve/cmd/dlv@latest >/dev/null 2>&1 || true
fi

echo
echo "✓ Dotfiles install complete."
echo "  Next steps if this was a fresh install:"
echo "    1. exec zsh                              # pick up new aliases / atuin"
echo "    2. tmux, then press <C-s> I              # install tmux plugins"
echo "    3. nvim, then :Lazy sync                 # install nvim plugins"
