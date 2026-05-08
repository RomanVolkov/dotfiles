#!/usr/bin/env zsh
# Two-stage kitty font switcher.
#
# Stage 1: pick the Nerd Font family (base name).
# Stage 2: pick the weight/style variant of that family.
# After confirming both, current-font.conf is rewritten and kitty
# reloads its config once.
#
# (Live preview during fzf was tried but `kitty @ load-config` is
# heavy enough that triggering it on every cursor move breaks
# terminal input — arrows, Esc, and search stop responding.)

set -e

CONF="${HOME}/.dotfiles/current-font.conf"

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
  --header "Stage 1/2 — Nerd Font family   (Enter=next · Esc=cancel)" \
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

# If only one variant exists (the base family itself), skip stage 2.
if [[ $(printf '%s\n' "$variants" | wc -l) -le 1 ]]; then
  variant="$family"
else
  variant=$(printf '%s\n' "$variants" | fzf \
    --prompt "Weight ❯ " \
    --header "Stage 2/2 — weight   (just $family = Regular)" \
    --no-multi)
fi

if [[ -z "$variant" ]]; then
  echo "Cancelled."
  exit 0
fi

# Write and reload once.
print -- "font_family $variant" > "$CONF"
kitty @ load-config 2>/dev/null || true
echo "Switched to: $variant"
echo "(Open a new kitty window if the current one doesn't update.)"
