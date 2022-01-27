#!/bin/zsh
# General install file of my setup
# Expects zsh to be installed

####################
# Helper functions #
####################

# Returns whether the given command is executable or aliased.
_has() {
  return $( whence $1 >/dev/null )
}

_nextfilename() {
  name=$1
  if [[ -e $name || -L $name ]] ; then
    i=1
    while [[ -e $name.$i || -L $namer.$i ]] ; do
        let i++
    done
    name=$name.$i
  fi
  echo $name
}

########
# Main #
########

# create directories if not exist
mkdir -pv $HOME/.cache/vim
mkdir -pv $HOME/.cache/zsh
mkdir -pv $HOME/.config/alacritty
mkdir -pv $HOME/.config/nvim
mkdir -pv $HOME/.ssh
mkdir -pv $HOME/.duplicacy

rm -Rf $HOME/.zplug

# required packages
sudo pacman -S \
  zsh tmux neovim curl gawk fzf the_silver_searcher \
  adobe-source-code-pro-fonts alacritty nodejs

# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# symlinks
# cp $HOME/.zshrc $(_nextfilename $HOME/zshrc.old)
rm -f $HOME/.zshrc
ln -s $HOME/dotfiles/zsh/zshrc.ecare $HOME/.zshrc

# cp $HOME/.vimrc $(_nextfilename $HOME/vimrc.old) # probably do not need backup
rm -f $HOME/.vimrc
ln -s $HOME/dotfiles/vim/vimrc $HOME/.vimrc

rm -f $HOME/.config/nvim/init.vim
ln -s $HOME/dotfiles/vim/vimrc $HOME/.config/nvim/init.vim

rm -f $HOME/.alacritty.yml
ln -s $HOME/dotfiles/alacritty/alacritty.yml.ecare $HOME/.alacritty.yml

rm -f $HOME/.tmux.conf
ln -s $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf

rm -f $HOME/.ssh/config
ln -s ~/dotfiles/ssh/config ~/.ssh/config

ln -s ~/dotfiles/duplicacy/filters ~/.duplicacy/filters

if _has conda; then
  conda config --set changeps1 False
fi

