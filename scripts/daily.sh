#!/usr/bin/env bash
# open current daily note inside Obsidian VAULT

VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/obsidian"
NOTE="$VAULT/daily/$(date +%Y-%m-%d).md" # daily note name

touch "$NOTE" # ensure today’s note exists

tmux new-window "cd $VAULT; nvim $NOTE"
