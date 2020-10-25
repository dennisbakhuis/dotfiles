#!/bin/bash

sudo apt install curl gawk zsh fzf silversearcher-ag

chsh -s /usr/bin/zsh

# create directories if not exist
mkdir -p $HOME/.cache/vim
mkdir -p $HOME/.cache/zsh
mkdir -p $HOME/.config/alacritty
rm -Rf $HOME/.zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
rm -f ~/.zshrc
ln -s ~/dotfiles/zsh/zshrc.linux ~/.zshrc
rm -f ~/.vimrc
ln -s ~/dotfiles/vim/vimrc ~/.vimrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
