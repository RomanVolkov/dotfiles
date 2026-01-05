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
export PATH="$HOME/.miniforge3/condabin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin/:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$GOPATH/bin/"
export PATH="$PATH:$HOME/dev/personal/scripts"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/romanvolkov/.local/bin:$PATH"
# export PATH="/Users/romanvolkov/nvim-macos-arm64/bin:$PATH"

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
sudo
per-directory-history # CTRL + G to toggle history buckets
poetry
)

source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey '^ ' autosuggest-accept # accept current suggestion by zsh-autosuggestions
bindkey '^K' up-line-or-history 
bindkey '^j' down-line-or-history 

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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/.miniforge3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/.miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/.miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/.miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


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

