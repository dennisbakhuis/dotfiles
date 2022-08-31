#!/bin/zsh

####################
# Helper functions #
####################

# Returns whether the given command is executable or aliased.
_has() {
  return $( whence $1 >/dev/null )
}

########
# Main #
########

# Update current system
sudo apt-get update && sudo apt-get -y upgrade

# create directories if not exist
mkdir -pv $HOME/.cache/zsh
mkdir -pv $HOME/.config/nvim

# install additional packages
sudo apt install -y zsh zplug tmux neovim curl gawk fzf silversearcher-ag nodejs meld lua5.3

# make zsh shell
sudo chsh -s $(which zsh) $(whoami)

# install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# symlink all config files
rm -f $HOME/.zshrc
ln -s $HOME/dotfiles/zsh/zshrc.azurevm $HOME/.zshrc

rm -f $HOME/.config/nvim/init.vim
ln -s $HOME/dotfiles/vim/vimrc $HOME/.config/nvim/init.vim

rm -f $HOME/.tmux.conf
ln -s $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf

# install vim environment for vim Python plugins
conda create -n vim python=3.10 neovim black

# do a vimplug install
nvim +'PlugInstall --sync' +qa
nvim +'UpdateRemotePlugins --sync' +qa

# remove env prompt in conda
if _has conda; then
  conda config --set changeps1 False
fi

# Use meld as diff tool in git
git config --global diff.tool meld

# Install Poetry
curl -sSL https://install.python-poetry.org | python3 -

