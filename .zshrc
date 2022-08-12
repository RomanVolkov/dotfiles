export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.rbenv/bin:$PATH"

export ZSH="/Users/romanvolkov/.oh-my-zsh"

ZSH_THEME="robbyrussell"


plugins=(git
brew
gem
zsh-autosuggestions
history-substring-search
history
iterm2
pip
docker
docker-compose
docker-machine
tmux
macos
sudo
)

source $ZSH/oh-my-zsh.sh
eval $(thefuck --alias)

export EDITOR='nvim'
alias v=nvim
alias vim=nvim
alias gcheckout='git checkout $(git branch | fzf)'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
eval "$(rbenv init - zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/romanvolkov/.miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/romanvolkov/.miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/romanvolkov/.miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/romanvolkov/.miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

