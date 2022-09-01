#!/bin/bash
###############################
# AzureML Compute prep script #
###############################
# Author: Dennis Bakhuis      #
# Date: 2022-09-01            #
###############################

# Update current system
sudo apt-get update && sudo apt-get -y upgrade

# create directories if not exist
mkdir -pv $HOME/.cache/zsh
mkdir -pv $HOME/.config/nvim
mkdir -pv $HOME/.zfunc
mkdir -pv $HOME/.config/python_keyring

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
conda create --name vim --channel conda-forge --force --yes python=3.9 neovim black

# do a vimplug install
nvim +'PlugInstall --sync' +'UpdateRemotePlugins' +qa

# Use meld as diff tool in git
git config --global diff.tool meld

# Install Poetry
curl -sSL https://install.python-poetry.org | python3 -
PATH=$PATH:~/.local/bin
poetry completions zsh > ~/.zfunc/_poetry

# Add TenneT private pypi repo
export PAT=$(ipython -c "from azureml.core import Workspace;ws=Workspace.from_config();kv=ws.get_default_keyvault();print(kv.get_secret('private-pypi-repo-pat-token-dennis'))")
echo "[backend]\ndefault-keyring=keyring.backends.fail.Keyring\n" > $HOME/.config/python_keyring/keyringrc.cfg
poetry config http-basic.tennet build "$PAT"

# Add rsa_id
ipython $HOME/dotfiles/azure_scripts/download_rsa_id.py
chmod 400 $HOME/.ssh/id_rsa

