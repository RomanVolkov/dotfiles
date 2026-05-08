# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# NOTE: nothing that can write to stdout (compinit, anything sourcing
# from non-existent paths, etc.) is allowed above this point — instant
# prompt would render whatever leaks through as visual garbage.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
ZSH_THEME="powerlevel10k/powerlevel10k"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Append extra completion dirs to fpath BEFORE oh-my-zsh runs compinit.
# Putting them here means OMZ's single compinit picks them up — we don't
# call compinit a second (or third) time. OpenSpec and Docker Desktop
# both expect their completions to live in the fpath at compinit time.
fpath=(
  "$HOME/.oh-my-zsh/custom/completions"
  "$HOME/.docker/completions"
  $fpath
)

export EDITOR='nvim'
export ZSH="$HOME/.oh-my-zsh"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export GOPATH=$HOME/go
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.docker/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin/:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$GOPATH/bin/"
export PATH="$PATH:$HOME/dev/personal/scripts"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/bin/omnisharp-roslyn:$PATH"
# export PATH="$HOME/nvim-macos-arm64/bin:$PATH"

# Guard each external init source — these files only exist on machines
# where the corresponding tool was actually installed, and unguarded
# `source` errors break shell startup on a fresh box.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

[ -f "$HOME/.env" ] && source "$HOME/.env"

plugins=(
zsh-autosuggestions
pip
docker
docker-compose
macos
# https://github.com/jeffreytse/zsh-vi-mode  — install:
#   git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
zsh-vi-mode
# Disabled (with reasons):
#   brew    — modern OMZ brew plugin is essentially empty (just a few stubs).
#   gem     — rubygems aliases; not used in this setup.
#   iterm2  — shell integration for iTerm; we use kitty.
#   history — `h`/`hsi` aliases; atuin used to replace them, fzf's
#             Ctrl+R now does the same.
#   tmux    — auto-launches tmux + wraps the binary, conflicts with
#             kitty.conf's shell line and breaks bash subshells.
#   sudo    — binds Esc-Esc to prepend sudo; conflicts with vi-mode's Esc.
#   per-directory-history (CTRL+G to toggle history buckets) — unused.
#   poetry  — unused.
)

source $ZSH/oh-my-zsh.sh

# fzf shell integration — ONE source, not two. `fzf --zsh` is the modern
# way (fzf >= 0.48); ~/.fzf.zsh is from the old install.sh and registers
# the same bindings, which used to clobber zvm's keymap on each prompt.
source <(fzf --zsh)

# Add `jk` as an alternate Esc — typed quickly in insert mode it
# leaves to normal mode. Standard Esc still works; this is a fallback
# that bypasses zsh's escape-sequence detection (the layer that gets
# fragile around fzf widgets, atuin async fetches, etc.).
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

# Custom keybindings live inside zsh-vi-mode's zvm_after_init_commands
# array (the array form is more reliable than the function callback —
# zvm guarantees these run after its own keymap reset on every line init,
# so they survive zvm's resets between prompts).
zvm_after_init_commands+=(
  # Pin bindings explicitly to the viins keymap. Without -M, bindkey
  # writes to whatever keymap is current at init time and the binding
  # can be lost across mode switches (Esc -> vicmd -> i -> viins).
  "bindkey -M viins '^ ' autosuggest-accept"   # Ctrl+Space — accept full suggestion
  "bindkey -M viins '^[[1;5C' forward-word"    # Ctrl+Right — accept one word
  "bindkey -M viins '^[[1;5D' backward-word"   # Ctrl+Left  — back one word
  # Remove fzf's Alt+C cd-widget — zoxide handles smart cd.
  "bindkey -M viins -r '^[c' 2>/dev/null"
  "bindkey -M vicmd -r '^[c' 2>/dev/null"
)

# (Removed the cursor-resync precmd hook — emitting escape sequences
# inline with the prompt was breaking zsh-vi-mode's Esc detection
# and rendering as visible garbage. Trust zvm's own cursor handling;
# if it desyncs after a specific command, fix that command's wrapper.)

alias vim=nvim
alias v=nvim
alias g=lazygit
# Inside kitty, prefer `kitten ssh` — it copies kitty's terminfo to the
# remote so cursor styling, hyperlinks, and graphics work even on hosts
# that don't ship xterm-kitty terminfo. Outside kitty, fall back to
# plain ssh. (No more `TERM=xterm-256color` workaround.)
if [ -n "$KITTY_WINDOW_ID" ] && command -v kitten >/dev/null 2>&1; then
  alias ssh='kitten ssh'
fi
alias k=kubectl
alias e='exit'
alias c='clear'
alias kf='~/.dotfiles/scripts/kitty-font.sh'

# Modern Unix replacements (only ls is overridden — find/cat/ps/du
# stay POSIX so scripts don't break; use fd/bat/procs/dust by name).
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --git --icons=auto --no-user'
  alias ll='eza -la --git --icons=auto --no-user'
  alias la='eza -la --git --icons=auto --no-user'
  alias lt='eza --tree --git-ignore --icons=auto --no-user'
fi
alias du='dust'   # alias: dust IS du-shaped, drop if it ever surprises you

# Inline image preview. Inside kitty (incl. through tmux thanks to
# allow-passthrough) we use kitten icat for native graphics-protocol
# rendering; otherwise fall back to chafa's ANSI approximation.
preview_image() {
  if [ -n "$KITTY_WINDOW_ID" ] && command -v kitten >/dev/null 2>&1; then
    kitten icat --align=left "$@"
  else
    chafa "$@"
  fi
  # kitten icat / chafa can leave the tty's keypad / line-discipline in
  # a state that breaks zsh-vi-mode's Esc detection. Reset and re-bind.
  stty sane 2>/dev/null
  if typeset -f zvm_select_vi_mode >/dev/null 2>&1; then
    zvm_select_vi_mode "$ZVM_MODE_INSERT" >/dev/null 2>&1
  fi
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# Docker Desktop's completions dir is added to fpath at the top of
# this file, before oh-my-zsh's compinit runs — so we don't need a
# second compinit call here.

# --cmd cd makes zoxide replace `cd` with its smart version (and `zi`
# becomes `cdi`). Plain `cd ./path`, `cd -`, `cd ~`, `cd` with no args
# all still work — zoxide falls through to the shell builtin when the
# argument doesn't match its frecency database.
eval "$(zoxide init zsh --cmd cd)"

# Ctrl+R history is provided by fzf's --zsh integration sourced above.


# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section

export BAT_THEME="Catppuccin Macchiato"

# Copy a file to the macOS clipboard. Auto-detects type:
#  · PNG / JPEG / GIF / TIFF / PDF  → bytes (pastes inline in Slack/Notes/Messages)
#  · anything else                  → file reference (pastes as attachment in Mail, file in Finder)
clipcopy() {
  if [ -z "$1" ]; then
    echo "usage: clipcopy <path>" >&2
    return 1
  fi
  local p
  p=$(realpath "$1" 2>/dev/null) || { echo "clipcopy: not found: $1" >&2; return 1; }
  if [ ! -f "$p" ]; then
    echo "clipcopy: not a file: $p" >&2
    return 1
  fi
  local ext=${p##*.}
  ext=${(L)ext}  # lowercase (zsh)
  local applescript
  case "$ext" in
    png)
      applescript="set the clipboard to (read POSIX file \"$p\" as «class PNGf»)" ;;
    jpg|jpeg)
      applescript="set the clipboard to (read POSIX file \"$p\" as JPEG picture)" ;;
    gif)
      applescript="set the clipboard to (read POSIX file \"$p\" as GIF picture)" ;;
    tif|tiff)
      applescript="set the clipboard to (read POSIX file \"$p\" as TIFF picture)" ;;
    pdf)
      applescript="set the clipboard to (read POSIX file \"$p\" as «class PDF »)" ;;
    *)
      applescript="tell app \"Finder\" to set the clipboard to POSIX file \"$p\"" ;;
  esac
  osascript -e "$applescript" && echo "copied: $p"
}
