#!/bin/bash

## Brew
## /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Oh my ZSH
## sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

## Brew
brew bundle

source ~/.zshrc

## symlinks
ln -s -f ~/.dotfiles/.zshrc ~/.zshrc
ln -s -f ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s -f ~/.dotfiles/.alacritty.toml ~/.alacritty.toml
ln -s -f ~/.dotfiles/coc-settings.json ~/.config/nvim/coc-settings.json
ln -s -f ~/.dotfiles/.condarc ~/.condarc
ln -s -f ~/.dotfiles/pycodestyle ~/.config
ln -s -f ~/.dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s -f ~/.dotfiles/pycodestyle ~/.config/pycodestyle
ln -s -f ~/.dotfiles/kitty.conf ~/.config/kitty/kitty.conf
ln -s -f ~/.dotfiles/current-theme.conf ~/.config/kitty/current-theme.conf
## inits
rbenv init

## go debugger
go install github.com/go-delve/delve/cmd/dlv@latest
