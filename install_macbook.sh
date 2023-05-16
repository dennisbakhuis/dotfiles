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
mkdir -pv $HOME/.zfunc

rm -Rf $HOME/.zplug

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# brew stuff
brew install tmux neovim curl gawk fzf the_silver_searcher nodejs exa

# enstall brew casks
brew tap homebrew/cask-fonts
brew install --cask font-source-code-pro
brew install --cask alacritty

# install zplug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

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
ln -s $HOME/dotfiles/alacritty/alacritty.yml.macbook $HOME/.alacritty.yml

rm -f $HOME/.tmux.conf
ln -s $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf

rm -f $HOME/.ssh/config
ln -s ~/dotfiles/ssh/config ~/.ssh/config

if _has conda; then
  conda config --set changeps1 False
fi

git config --global core.excludesfile ~/.gitignore
