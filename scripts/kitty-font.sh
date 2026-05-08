#!/usr/bin/env zsh
# Two-stage kitty font switcher with live preview.
#
# Stage 1: pick the Nerd Font family (base name).
# Stage 2: pick the weight/style variant of that family.
#
# As you scroll either list, the font is applied live to every kitty
# window — fzf fires its `focus` event on each cursor move, which
# rewrites ~/.dotfiles/current-font.conf and runs `kitty @ load-config`.
# Press Enter to confirm, Esc to cancel (restores original font).
#
# Requires: allow_remote_control yes + listen_on in kitty.conf
# (already set). Live preview only works in kitty >= ~0.40 where
# load-config reloads font_family. Older versions still update the
# config file but only new windows pick up the change.

set -e

CONF="${HOME}/.dotfiles/current-font.conf"
ORIG_FONT=$(grep -E '^font_family' "$CONF" 2>/dev/null | sed 's/^font_family[[:space:]]*//')

# Restore original font + reload — used on cancel and on errors.
restore() {
  if [[ -n "$ORIG_FONT" ]]; then
    print -- "font_family $ORIG_FONT" > "$CONF"
    kitty @ load-config 2>/dev/null || true
  fi
}
trap restore INT TERM

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

# fzf focus-binding: on every cursor move write the highlighted line
# to current-font.conf and ask kitty to reload.
PREVIEW='print -- "font_family {}" > '"$CONF"' && kitty @ load-config 2>/dev/null'

family=$(printf '%s\n' "$base_families" | fzf \
  --prompt "Family ❯ " \
  --header "Stage 1/2 — Nerd Font family   (Enter=next · Esc=cancel)" \
  --no-multi \
  --bind "focus:execute-silent($PREVIEW)")

if [[ -z "$family" ]]; then
  restore
  echo "Cancelled."
  exit 0
fi

# ----- Stage 2: pick weight variant of the chosen family -----
# Match anything starting with "$family", optionally followed by a
# weight word (Light, Med, SemBd, Ret, Bold, …).
variants=$(fc-list :mono family \
  | tr ',' '\n' \
  | sed 's/^[[:space:]]*//' \
  | grep -E "^${family}([[:space:]]|\$)" \
  | sort -u)
# Make sure the base family is in there even if fc-list lists only variants.
variants=$(printf '%s\n%s' "$family" "$variants" | sort -u)

# If only one variant exists (the base family itself), skip stage 2.
if [[ $(printf '%s\n' "$variants" | wc -l) -le 1 ]]; then
  variant="$family"
else
  variant=$(printf '%s\n' "$variants" | fzf \
    --prompt "Weight ❯ " \
    --header "Stage 2/2 — weight   (just $family = Regular)" \
    --no-multi \
    --bind "focus:execute-silent($PREVIEW)")
fi

if [[ -z "$variant" ]]; then
  restore
  echo "Cancelled."
  exit 0
fi

# Confirm and persist.
print -- "font_family $variant" > "$CONF"
kitty @ load-config 2>/dev/null || true
echo "Switched to: $variant"
