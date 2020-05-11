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
mkdir -p $HOME/.cache/vim
mkdir -p $HOME/.cache/zsh
mkdir -p $HOME/.config/alacritty

# install requirements
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux detected..."

    # Check curl installed
    if ! _has curl; then
      echo "curl not detected, installing..."
      sudo apt-get install curl
    fi

    # Check curl installed
    if ! _has gawk; then
      echo "gawk not detected, installing..."
      sudo apt-get install gawk
    fi

    # Check if zplug is installed
    if ! _has zplug; then
      echo "zPlug not detected, installing..."
      rm -Rf $HOME/.zplug
      # export ZPLUG_HOME=$HOME/.zplug
      # git clone https://github.com/zplug/zplug $ZPLUG_HOME
      curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
      source $HOME/.zplug/init.zsh
      # sudo apt-get install zplug
      # source /usr/share/zplug/init.zsh
    fi

    # Check fzf is installed
    if ! _has fzf; then
      echo "fzf not detected, installing..."
      sudo apt-get install fzf
    fi

    # Check ag is isntalled
    if ! _has ag; then
      echo "ag not detected, installing..."
      sudo apt-get install silversearcher-ag
    fi

    # create zsh symlinks
    cp ~/.zshrc $(_nextfilename ~/zshrc.old)
    rm -f ~/.zshrc
    ln -s ~/dotfiles/zsh/zshrc.ecare ~/.zshrc

elif [[ "$OSTYPE" == "darwin"* ]] ; then
    echo "MacOs detected..."


    # Mac ssh settings git
    mkdir -p ~/.ssh
    rm -f ~/.ssh/config
    ln -s ~/dotfiles/ssh/config ~/.ssh/config

else
    echo "Error: unknown OS"
    exit 1
fi

# create vim symlinks
# cp ~/.vimrc $(_nextfilename ~/vimrc.old) # probably do not need backup
rm -f ~/.vimrc
ln -s ~/dotfiles/vim/vimrc ~/.vimrc

# turn off conda prompt
conda config --set changeps1 False

# install zsh plugins
# source ~/.zshrc
# zplug install

