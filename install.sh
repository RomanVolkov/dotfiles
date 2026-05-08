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
ln -s -f ~/.dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s -f ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s -f ~/.dotfiles/.aerospace.toml ~/.aerospace.toml
ln -s -f ~/.dotfiles/kitty.conf ~/.config/kitty/kitty.conf
ln -s -f ~/.dotfiles/current-theme.conf ~/.config/kitty/current-theme.conf
ln -s -f ~/.dotfiles/current-font.conf ~/.config/kitty/current-font.conf
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/yazi ~/.config/yazi
ln -s ~/.dotfiles/opencode ~/.config/opencode
ln -s ~/.dotfiles/eligere ~/.config/eligere

## tmux plugin manager (TPM) — required for the plugins listed in
## .tmux.conf (sensible, resurrect, continuum). After this clone,
## launch tmux and press <prefix> + I to install the plugins.
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

defaults write net.kovidgoyal.kitty ApplePressAndHoldEnabled -bool false
