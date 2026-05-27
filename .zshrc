# ============================================================================
# Powerlevel10k instant prompt
# ----------------------------------------------------------------------------
# Must stay near the top. Anything that writes to stdout above this block
# (compinit, unguarded sources, echoing inits) leaks into the prompt as
# visible garbage and defeats the instant-prompt benefit.
# ============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
ZSH_THEME="powerlevel10k/powerlevel10k"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================================
# Core env
# ============================================================================
export EDITOR='nvim'
export ZSH="$HOME/.oh-my-zsh"
export GOPATH="$HOME/go"
export BAT_THEME="Catppuccin Macchiato"

# ============================================================================
# PATH
# ----------------------------------------------------------------------------
# Homebrew front-loaded so its tools win over /usr/local. Tool-specific
# bin dirs (mason, lmstudio, omnisharp) follow. $GOPATH/bin is appended
# rather than prepended so it can't shadow brew-installed tools.
# ============================================================================
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.docker/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="/usr/local/bin/omnisharp-roslyn:$PATH"
export PATH="$HOME/.lmstudio/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/dev/personal/scripts"

# ============================================================================
# fpath — extra completion dirs (BEFORE oh-my-zsh runs compinit)
# ----------------------------------------------------------------------------
# OMZ runs the single compinit. Adding completion dirs here lets that
# one call see them; we don't need (and don't want) extra compinit calls.
# ============================================================================
fpath=(
  "$HOME/.oh-my-zsh/custom/completions"
  "$HOME/.docker/completions"
  $fpath
)

# ============================================================================
# oh-my-zsh plugins
# ============================================================================
plugins=(
  zsh-autosuggestions
  pip
  docker
  docker-compose
  macos
  # https://github.com/jeffreytse/zsh-vi-mode — clone manually:
  #   git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
  zsh-vi-mode
  # Disabled (with reasons):
  #   brew    — modern OMZ brew plugin is essentially empty.
  #   gem     — rubygems aliases; unused here.
  #   iterm2  — shell integration for iTerm; we use kitty.
  #   history — `h`/`hsi` aliases; fzf's Ctrl+R replaces them.
  #   tmux    — auto-launches tmux + wraps the binary, conflicts with
  #             kitty.conf's shell line and breaks bash subshells.
  #   sudo    — binds Esc-Esc to prepend sudo; conflicts with vi-mode Esc.
)

# ============================================================================
# External env files (guarded — only present when the tool is installed)
# ============================================================================
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -f "$HOME/.env" ]       && source "$HOME/.env"

# ============================================================================
# Load oh-my-zsh
# ============================================================================
source "$ZSH/oh-my-zsh.sh"

# ============================================================================
# fzf shell integration
# ----------------------------------------------------------------------------
# `fzf --zsh` is the modern way (fzf >= 0.48). Don't ALSO source
# ~/.fzf.zsh from the old install.sh — both register the same bindings
# and the duplicate sourcing used to clobber zvm's keymap on each prompt.
# Provides Ctrl+R history search.
# ============================================================================
source <(fzf --zsh)

# ============================================================================
# zsh-vi-mode bindings
# ----------------------------------------------------------------------------
# Custom binds live inside zvm_after_init_commands (the array form, not
# the function callback). zvm guarantees these run after its own keymap
# reset on every line init, so they survive across mode switches.
# ============================================================================
# `jk` as an alternate Esc — bypasses zsh's escape-sequence detection,
# which gets fragile around fzf widgets and async region updates.
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

zvm_after_init_commands+=(
  # Pin to viins explicitly. Without -M, bindkey writes to whichever
  # keymap is current at init time and the bind is lost across mode
  # switches (Esc → vicmd → i → viins).
  "bindkey -M viins '^ ' autosuggest-accept"   # Ctrl+Space — accept suggestion
  "bindkey -M viins '^[[1;5C' forward-word"    # Ctrl+Right  — accept one word
  "bindkey -M viins '^[[1;5D' backward-word"   # Ctrl+Left   — back one word
  # Drop fzf's Alt+C cd-widget; zoxide's smart cd already covers it.
  "bindkey -M viins -r '^[c' 2>/dev/null"
  "bindkey -M vicmd -r '^[c' 2>/dev/null"
)

# ============================================================================
# zoxide — smart cd
# ----------------------------------------------------------------------------
# `--cmd cd` replaces the cd builtin (and `zi` becomes `cdi`). Plain
# `cd ./path`, `cd -`, `cd ~`, `cd` with no args still work — zoxide
# falls through to the builtin when the argument doesn't match its
# frecency database.
# ============================================================================
eval "$(zoxide init zsh --cmd cd)"

# ============================================================================
# Aliases
# ============================================================================
alias vim=nvim
alias v=nvim
alias g=lazygit
alias k=kubectl
alias e=exit
alias c=clear
alias kf='~/.dotfiles/scripts/kitty-font.sh'
alias cc=claude

# Modern Unix replacements — only `ls` is overridden so POSIX scripts
# still work; reach for fd/bat/procs/dust by their real names.
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --git --icons=auto --no-user'
  alias ll='eza -la --git --icons=auto --no-user'
  alias la='eza -la --git --icons=auto --no-user'
  alias lt='eza --tree --git-ignore --icons=auto --no-user'
fi
alias du=dust  # dust output IS du-shaped; drop this alias if it ever surprises.

# Inside kitty, `kitten ssh` propagates kitty terminfo to the remote
# so cursor styling, hyperlinks, and graphics work without xterm-kitty
# terminfo on the far side. Outside kitty, fall through to plain ssh.
if [ -n "$KITTY_WINDOW_ID" ] && command -v kitten >/dev/null 2>&1; then
  alias ssh='kitten ssh'
fi

# ============================================================================
# Functions
# ============================================================================

# Inline image preview. Inside kitty (incl. through tmux via
# allow-passthrough) uses kitten icat for the native graphics protocol;
# otherwise falls back to chafa's ANSI approximation.
preview_image() {
  if [ -n "$KITTY_WINDOW_ID" ] && command -v kitten >/dev/null 2>&1; then
    kitten icat --align=left "$@"
  else
    chafa "$@"
  fi
  # icat/chafa can leave the tty's keypad / line-discipline in a state
  # that breaks zsh-vi-mode's Esc detection. Reset and re-arm insert mode.
  stty sane 2>/dev/null
  if typeset -f zvm_select_vi_mode >/dev/null 2>&1; then
    zvm_select_vi_mode "$ZVM_MODE_INSERT" >/dev/null 2>&1
  fi
}

# Open yazi and `cd` to wherever it left off.
y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Copy a file to the macOS clipboard, auto-detecting type:
#   PNG/JPEG/GIF/TIFF/PDF → bytes (pastes inline in Slack/Notes/Messages)
#   anything else         → file reference (Mail attachment / Finder file)
clipcopy() {
  if [ -z "$1" ]; then
    echo "usage: clipcopy <path>" >&2
    return 1
  fi
  local p
  p="$(realpath "$1" 2>/dev/null)" || { echo "clipcopy: not found: $1" >&2; return 1; }
  if [ ! -f "$p" ]; then
    echo "clipcopy: not a file: $p" >&2
    return 1
  fi
  local ext=${(L)p##*.}
  local applescript
  case "$ext" in
    png)        applescript="set the clipboard to (read POSIX file \"$p\" as «class PNGf»)" ;;
    jpg|jpeg)   applescript="set the clipboard to (read POSIX file \"$p\" as JPEG picture)" ;;
    gif)        applescript="set the clipboard to (read POSIX file \"$p\" as GIF picture)" ;;
    tif|tiff)   applescript="set the clipboard to (read POSIX file \"$p\" as TIFF picture)" ;;
    pdf)        applescript="set the clipboard to (read POSIX file \"$p\" as «class PDF »)" ;;
    *)          applescript="tell app \"Finder\" to set the clipboard to POSIX file \"$p\"" ;;
  esac
  osascript -e "$applescript" && echo "copied: $p"
}

# eza colors matching yazi (truecolor: 38;2;R;G;B)
export EZA_COLORS="di=38;2;124;157;219:ex=38;2;166;218;149:*.md=38;2;202;211;245"
