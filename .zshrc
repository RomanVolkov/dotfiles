export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.docker/bin:$PATH"

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
swiftpm # swift package completion-tool generate-zsh-script > ~/.oh-my-zsh/completions/_swift
)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'
alias v=nvim
alias vim=nvim
alias gcheckout='git checkout $(git branch | fzf)'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
eval "$(rbenv init - zsh)"

