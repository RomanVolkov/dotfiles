#!/usr/bin/env zsh
# Three-stage kitty font picker.
#
# Stage 1: pick the Nerd Font family (base name).
# Stage 2: pick the weight/style variant of that family.
# Stage 3: pick the font size (12-20).
# After confirming all three, current-font.conf is rewritten and the
# running kitty window is refreshed via `kitty @ set-font-size --all`,
# which both applies the size AND forces a font re-render so the new
# family/weight take effect without opening a new window.

set -e

CONF="${HOME}/.dotfiles/current-font.conf"
KITTY_CONF="${HOME}/.dotfiles/kitty.conf"

# ----- Helpers -----
# Read current font_size from current-font.conf, falling back to kitty.conf,
# then to 16 if neither has one.
get_current_size() {
  local size
  size=$(grep -E '^font_size' "$CONF" 2>/dev/null | awk '{print $2}' | head -1)
  [[ -z "$size" ]] && size=$(grep -E '^font_size' "$KITTY_CONF" 2>/dev/null | awk '{print $2}' | head -1)
  # strip trailing .0 so it lines up with integer sizes in the picker
  size=${size%.0}
  echo "${size:-16}"
}

# ----- Stage 1: pick base family -----
base_families=$(fc-list :mono family \
  | tr ',' '\n' \
  | sed 's/^[[:space:]]*//' \
  | grep -E "Nerd Font( Mono| Propo)?$" \
  | sort -u)

if [[ -z "$base_families" ]]; then
  echo "No Nerd Fonts installed. Run:  brew bundle --file=~/.dotfiles/Brewfile" >&2
  exit 1
fi

family=$(printf '%s\n' "$base_families" | fzf \
  --prompt "Family ❯ " \
  --header "Stage 1/3 — Nerd Font family   (Enter=next · Esc=cancel)" \
  --no-multi)

if [[ -z "$family" ]]; then
  echo "Cancelled."
  exit 0
fi

# ----- Stage 2: pick weight variant of the chosen family -----
variants=$(fc-list :mono family \
  | tr ',' '\n' \
  | sed 's/^[[:space:]]*//' \
  | grep -E "^${family}([[:space:]]|\$)" \
  | sort -u)
variants=$(printf '%s\n%s' "$family" "$variants" | sort -u)

if [[ $(printf '%s\n' "$variants" | wc -l) -le 1 ]]; then
  variant="$family"
else
  variant=$(printf '%s\n' "$variants" | fzf \
    --prompt "Weight ❯ " \
    --header "Stage 2/3 — weight   (just $family = Regular)" \
    --no-multi)
fi

if [[ -z "$variant" ]]; then
  echo "Cancelled."
  exit 0
fi

# ----- Stage 3: pick font size -----
current_size=$(get_current_size)

size=$(seq 12 20 | fzf \
  --prompt "Size ❯ " \
  --header "Stage 3/3 — font size 12-20   (current: $current_size)" \
  --query "$current_size" \
  --no-multi)

if [[ -z "$size" ]]; then
  echo "Cancelled."
  exit 0
fi

# ----- Write and refresh -----
{
  print -- "font_family $variant"
  print -- "font_size $size"
} > "$CONF"

# load-config picks up font_family changes; set-font-size --all forces
# a font re-render across every kitty window using the new family.
kitty @ load-config 2>/dev/null || true

# kitty does NOT reliably hot-reload font_family in already-rendered
# windows — the running window keeps its cached font atlas. Workarounds
# (set-font-size nudge, action triggers, etc.) are flaky across kitty
# versions. Reliable solution: spawn a fresh kitty OS window, which
# always picks up the new config.
kitty @ launch --type=os-window 2>/dev/null || true

echo "Switched to: $variant @ ${size}pt"
echo "(A new kitty window was opened with the new font."
echo " Close this old one when ready: exit, or Cmd+W.)"
