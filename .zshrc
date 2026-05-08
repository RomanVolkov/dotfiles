# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("/Users/romanvolkov/.oh-my-zsh/custom/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
ZSH_THEME="powerlevel10k/powerlevel10k"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export EDITOR='nvim'
export ZSH="/Users/romanvolkov/.oh-my-zsh"
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
export PATH="/Users/romanvolkov/.local/bin:$PATH"
export PATH="/Users/romanvolkov/.cargo/bin:$PATH"
export PATH="/usr/local/bin/omnisharp-roslyn:$PATH"
# export PATH="/Users/romanvolkov/nvim-macos-arm64/bin:$PATH"

. "$HOME/.cargo/env"

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

source ~/.env

plugins=(
brew
gem
zsh-autosuggestions
history
iterm2
pip
docker
docker-compose
tmux
macos
# 'sudo' plugin is intentionally disabled: it binds double-Esc to
# prepend sudo, which conflicts with vi-mode's Esc and randomly adds
# 'sudo' when switching modes.
# per-directory-history # CTRL + G to toggle history buckets
# poetry
# https://github.com/jeffreytse/zsh-vi-mode
## git clone https://github.com/jeffreytse/zsh-vi-mode \
  # $ZSH_CUSTOM/plugins/zsh-vi-mode
zsh-vi-mode
)

source $ZSH/oh-my-zsh.sh

# fzf shell integration — ONE source, not two. `fzf --zsh` is the modern
# way (fzf >= 0.48); ~/.fzf.zsh is from the old install.sh and registers
# the same bindings, which used to clobber zvm's keymap on each prompt.
source <(fzf --zsh)

# Custom keybindings live inside zsh-vi-mode's zvm_after_init_commands
# array (the array form is more reliable than the function callback —
# zvm guarantees these run after its own keymap reset on every line init,
# so they survive zvm's resets between prompts).
zvm_after_init_commands+=(
  "bindkey '^ ' autosuggest-accept"           # Ctrl+Space — accept full suggestion
  "bindkey '^[[1;5C' forward-word"            # Ctrl+Right — accept one word
  "bindkey '^[[1;5D' backward-word"           # Ctrl+Left  — back one word
)

alias vim=nvim
alias v=nvim
alias g=lazygit
alias ssh='TERM=xterm-256color ssh'
alias k=kubectl
alias e='exit'
alias c='clear'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/romanvolkov/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/romanvolkov/.google-cloud-sdk/path.zsh.inc' ]; then . '/Users/romanvolkov/.google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/romanvolkov/.google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/romanvolkov/.google-cloud-sdk/completion.zsh.inc'; fi

eval "$(zoxide init zsh)"


# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/romanvolkov/.lmstudio/bin"
# End of LM Studio CLI section

export BAT_THEME="Catppuccin Mocha"
