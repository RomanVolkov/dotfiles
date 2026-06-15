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

# Remove nerd-font files in ~/Library/Fonts that brew doesn't own. These
# come from manually downloading fonts from nerdfonts.com and cause brew
# casks to abort with "existing Font is different from the one being
# installed". Files/symlinks that match a name in /opt/homebrew/Caskroom/font-*
# are kept (brew already manages them).
purge_legacy_nerd_fonts() {
  local fonts_dir="$HOME/Library/Fonts"
  [ -d "$fonts_dir" ] || return 0

  local cask_root
  cask_root="$(brew --prefix 2>/dev/null)/Caskroom"
  # Collect owned fonts: actual files AND symlinks from brew's caskroom.
  # Symlinks are important because modern Homebrew uses them exclusively.
  local owned=""
  if [ -d "$cask_root" ]; then
    owned=$(find "$cask_root"/font-* \( -type f -o -type l \) \( -name '*.ttf' -o -name '*.otf' \) 2>/dev/null \
            | xargs -n1 basename 2>/dev/null | sort -u)
  fi

  shopt -s nullglob
  local f base removed=0
  for f in "$fonts_dir"/*Nerd*.ttf "$fonts_dir"/*Nerd*.otf; do
    base=$(basename "$f")
    if [ -z "$owned" ] || ! printf '%s\n' "$owned" | grep -qFx "$base"; then
      echo "  purging legacy nerd-font: $base"
      rm -f -- "$f"
      removed=$((removed + 1))
    fi
  done
  shopt -u nullglob
  [ "$removed" -gt 0 ] && echo "  removed $removed legacy nerd-font file(s) — brew bundle will reinstall"
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
# Refresh + upgrade existing formulae before installing new ones from
# the Brewfile. Catches dependency-version mismatches (e.g. libgit2
# vs llhttp) that otherwise surface as runtime dyld errors.
brew update
brew upgrade
# Clear any manually-downloaded nerd fonts that don't match brew's
# expected hashes — otherwise the matching cask aborts with "existing
# Font is different from the one being installed". Conservative: only
# removes files brew doesn't already own. Now includes symlinks.
purge_legacy_nerd_fonts
# `--force` is a belt-and-suspenders fallback: even if a file slips
# past purge_legacy_nerd_fonts, brew will overwrite it instead of
# refusing to install.
HOMEBREW_CASK_OPTS="--force" brew bundle --file="$DOTFILES/Brewfile"
brew cleanup

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

# Karabiner-Elements: must COPY, not symlink. Karabiner atomically
# replaces the file (destroying any symlink) whenever it saves — e.g. a
# UI change (Devices tab "Modify events" toggle) or config-format
# migration on update. $DOTFILES/karabiner/karabiner.json is the single
# source of truth, so we overwrite the live config on every run, backing
# up the previous one first in case it held unsynced UI tweaks. Edit the
# config in the repo (not the Karabiner UI), then re-run this script.
mkdir -p "$HOME/.config/karabiner"
kb_live="$HOME/.config/karabiner/karabiner.json"
if [ -f "$kb_live" ] && ! cmp -s "$DOTFILES/karabiner/karabiner.json" "$kb_live"; then
  cp "$kb_live" "$kb_live.bak"
fi
cp -f "$DOTFILES/karabiner/karabiner.json" "$kb_live"

# ~/.config directory configs
link "$DOTFILES/nvim"     "$HOME/.config/nvim"
link "$DOTFILES/yazi"     "$HOME/.config/yazi"
link "$DOTFILES/opencode" "$HOME/.config/opencode"
link "$DOTFILES/eligere"  "$HOME/.config/eligere"
link "$DOTFILES/eza"      "$HOME/.config/eza"

## ----- tmux plugin manager (TPM) -----
# After this script: launch tmux and press <prefix> + I to install plugins.
if [ ! -d "$TPM_DIR" ]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

## ----- yazi packages -----
# Installs every dep in yazi/package.toml (catppuccin flavor, plugins).
# Idempotent: pinned by rev+hash, re-runs are no-ops if already deployed.
if command -v ya >/dev/null 2>&1; then
  ya pkg install >/dev/null 2>&1 || true
fi

## ----- macOS tweaks -----
# Disable press-and-hold for keys (let kitty's vim-mode key repeats work).
defaults write net.kovidgoyal.kitty ApplePressAndHoldEnabled -bool false

## ----- Optional one-shot installs -----
# (delve is now installed via Brewfile; nothing to do here.)

echo
echo "✓ Dotfiles install complete."
echo "  Next steps if this was a fresh install:"
echo "    1. exec zsh                              # pick up new aliases / atuin"
echo "    2. tmux, then press <C-s> I              # install tmux plugins"
echo "    3. nvim, then :Lazy sync                 # install nvim plugins"
