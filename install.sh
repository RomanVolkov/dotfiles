#!/bin/bash

## Brew
## /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Oh my ZSH
## sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## Brew
brew bundle

##Vim
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
/usr/local/bin/pip install neovim
/usr/local/bin/pip install --upgrade neovim

mkdir ~/.config/nvim/themes
cp themes/onedark.vim ~/.config/nvim/themes

source ~/.zshrc

## symlinks
ln -s -f ~/.dotfiles/init.vim ~/.config/nvim/init.vim
ln -s -f ~/.dotfiles/.zshrc ~/.zshrc
ln -s -f ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s -f ~/.dotfiles/.alacritty.yml ~/.alacritty.yml
ln -s -f ~/.dotfiles/coc-settings.json ~/.config/nvim/coc-settings.json
ln -s -f ~/.dotfiles/.condarc ~/.condarc
mkdir ~/.config/nvim/lua
ln -s -f ~/.dotfiles/go_debug.lua ~/.config/nvim/lua/go_debug.lua
## inits
rbenv init
