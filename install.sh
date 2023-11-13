#!/bin/zsh
#########################################
# Main install script                   #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-12                      #
#########################################
set -e  # Exit script immediately on first error.


####################
# Helper functions #
####################

# Returns whether the given command is executable or aliased.
_has() {
  return $( whence $1 >/dev/null )
}


###########
# General #
###########
export HOSTNAME=$(hostname -s)  # get hostname

# create directories if not exist
mkdir -pv $HOME/.cache/zsh
mkdir -pv $HOME/.config/wezterm
mkdir -pv $HOME/.config/zsh
mkdir -pv $HOME/.ssh
mkdir -pv $HOME/.zfunc

# remove old stuff
rm -Rf $HOME/.zplug


# install software check linux or mac
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Arch Linux"
    
    # install paru (needs to build using rust)
    if ! _has paru; then
        pacman -S --needed git base-devel && git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si && cd .. && rm -rf paru
    fi
    
    # install packages
    sudo pacman -S tmux neovim curl gawk fzf nodejs exa starship ripgrep fd neofetch
    
    # install GUI packages
    if [[ "$USE_GUI" == 1 ]]; then
        echo "GUI used..."
        sudo pacman -S wezterm ttf-firacode-nerd-font adobe-source-code-pro-fonts
    fi

    # install miniconda
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
    bash ~/miniconda.sh -b -p $HOME/miniconda
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Mac OSX"
    # install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install tmux neovim curl gawk fzf nodejs exa starship fd
    brew tap homebrew/cask-fonts
    brew install --cask font-source-code-pro wezterm font-fira-mono-nerd-font
    brew tap nidnogg/zeitfetch
    brew install zeitfetch

    # Install miniconda
    curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o ~/miniconda.sh
    bash ~/miniconda.sh -b -p $HOME/miniconda
else
    echo "Unknown OS"
fi

# install zplug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

############
# symlinks #
############

# zshrc
rm -f $HOME/.zshrc
ZSH_CONFIG_NAME="zshrc.$HOSTNAME"
if ! [[ -f $HOME/dotfiles/zsh/$ZSH_CONFIG_NAME ]]; then
    cp $HOME/dotfiles/zsh/zshrc.base $HOME/dotfiles/zsh/$ZSH_CONFIG_NAME
fi
ln -s $HOME/dotfiles/zsh/$ZSH_CONFIG_NAME $HOME/.zshrc

# nvim
rm -rf $HOME/.config/nvim
ln -s $HOME/dotfiles/nvim $HOME/.config/nvim

rm -f $HOME/.alacritty.yml $HOME/.config/alacritty/alacritty.yml
ln -s $HOME/dotfiles/alacritty/alacritty.yml.macbook $HOME/.config/alacritty/alacritty.yml
rm -f $HOME/.wezterm.lua $HOME/.config/wezterm/wezterm.lua
ln -s $HOME/dotfiles/wezterm/wezterm.lua $HOME/.config/wezterm/wezterm.lua

rm -f $HOME/.tmux.conf
ln -s $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf

rm -f $HOME/.ssh/config
ln -s ~/dotfiles/ssh/config ~/.ssh/config

rm -f $HOME/.ignore
rm -f $HOME/.gitconfig
ln -s ~/dotfiles/git/ignore ~/.ignore
ln -s ~/dotfiles/git/gitconfig ~/.gitconfig

git config --global core.excludesfile ~/.gitignore


