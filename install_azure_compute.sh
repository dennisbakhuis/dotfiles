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
sudo apt install -y zsh zplug tmux neovim curl gawk fzf silversearcher-ag nodejs meld

# make zsh shell
chsh -s $(which zsh)

# symlink all config files
rm -f $HOME/.zshrc
ln -s $HOME/dotfiles/zsh/zshrc.tennet $HOME/.zshrc

rm -f $HOME/.config/nvim/init.vim
ln -s $HOME/dotfiles/vim/vimrc $HOME/.config/nvim/init.vim

rm -f $HOME/.tmux.conf
ln -s $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf

# remove env prompt in conda
if _has conda; then
  conda config --set changeps1 False
fi

# Use meld as diff tool in git
git config --global diff.tool meld

