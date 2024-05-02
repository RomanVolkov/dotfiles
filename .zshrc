# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.docker/bin:$PATH"
export PATH="$HOME/.miniforge3/condabin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin/:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export EDITOR='nvim'
export PATH="$PATH:$HOME/.rvm/bin"
export ZSH="/Users/romanvolkov/.oh-my-zsh"
export PATH="/opt/homebrew/Cellar/ruby/3.3.0/bin:$PATH"

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# export GOROOT="/opt/homebrew/bin/go"
# export PATH=$PATH:$GOROOT/bin

# Experiments with Swift WASM
# export PATH="/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:$PATH"
# export PATH="/Library/Developer/Toolchains/swift-wasm-5.7.3-RELEASE.xctoolchain/usr/bin:$PATH"
 
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git
brew
gem
zsh-autosuggestions
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
per-directory-history # CTRL + G to toggle history buckets
)

source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey '^ ' autosuggest-accept # accept current suggestion by zsh-autosuggestions
alias vim=nvim
alias ggg=lazygit

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


