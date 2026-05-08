#!/usr/bin/env zsh
# Quickly switch kitty's font.
#
# Lists the family names of monospaced fonts installed on the system,
# fuzzy-picks one with fzf, writes it to ~/.dotfiles/current-font.conf,
# then asks kitty to reload its config.
#
# Note: kitty's load-config reloads everything BUT font_family for
# already-open windows in some kitty versions. If the running window
# doesn't visibly switch, open a fresh kitty window or run
#   kitten @ set-font-size <current-size>
# to force a re-render. The new font is the new default for any new
# window opened after the script runs.

set -e

CONF=${HOME}/.dotfiles/current-font.conf
current=$(grep -E '^font_family' "$CONF" 2>/dev/null | sed 's/^font_family[[:space:]]*//' | head -1)

# List monospaced font families that include Nerd Font glyphs (icons in
# nvim / lazygit / yazi rely on these glyphs — picking a non-nerd font
# would render boxes instead). Only show base family names ending in
# "Nerd Font", "Nerd Font Mono", or "Nerd Font Propo" — weight/style
# variants like "FiraCode Nerd Font Light" or "Med" are filtered out.
fonts=$(fc-list :mono family | tr ',' '\n' | sed 's/^[[:space:]]*//' \
  | grep -E "Nerd Font( Mono| Propo)?$" | sort -u)
if [[ -z "$fonts" ]]; then
  echo "No Nerd Font families found." >&2
  echo "Install some via:  brew bundle --file=~/.dotfiles/Brewfile" >&2
  exit 1
fi

selected=$(printf '%s\n' "$fonts" | fzf \
  --prompt "kitty font ❯ " \
  --header "Pick a font for kitty (Esc to cancel)" \
  --query "$current" \
  --no-multi)

if [[ -z "$selected" ]]; then
  echo "Cancelled."
  exit 0
fi

if [[ "$selected" == "$current" ]]; then
  echo "Already using: $selected"
  exit 0
fi

printf 'font_family %s\n' "$selected" > "$CONF"

# Tell kitty to reload. Errors here are non-fatal — script still
# succeeds because the file is updated and a fresh kitty window will
# pick it up.
if command -v kitty >/dev/null 2>&1; then
  kitty @ load-config 2>/dev/null || true
fi

echo "Switched to: $selected"
echo "(Open a new kitty window if the current one doesn't update.)"
