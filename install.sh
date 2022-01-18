#!/bin/bash

## Oh my ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## Brew
brew bundle

## symlinks
ln -s -f ~/.dotfiles/.vimrc ~/.vimrc
ln -s -f ~/.dotfiles/.zshrc ~/.zshrc
ln -s -f ~/.dotfiles/.tmux.conf ~/.tmux.conf

##Vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir ~/.vim/themes/
cp themes/onedark.vim ~/.vim/themes/onedark.vim

source ~/.zshrc

## inits
rbenv init
