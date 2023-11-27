#!/bin/sh
#################################################
# Install script for my configs on new machines #
#                                               #
# This script is independent of OS (Mac/Arch)   #
# And installs my default environment           #
#                                               #
# Make sure that a hostname is set up as this   #
# is used for some configs                      #
#                                               #
# Author: Dennis Bakhuis                        #
# Date: 2023-11-25                              #
#################################################
INSTALLER_VERSION=0.1.0     # Version of this installer
set -e                      # Exit script immediately on first error.


#########################################
# General settings and helper functions #
#########################################
export BASE_USER=${BASE_USER:-dennis}     # User to be created in Arch with sudo rights
export DOTFILES_ROOT=$(pwd)                                     # Location of the dotfiles

# if BASE_PASSWORD is not set, ask for it
if [ -z "$BASE_PASSWORD" ]; then
    printf " *** Enter password for user \`$BASE_USER\`: "
    read -s BASE_PASSWORD
    printf "\n"
fi

# if hostname is not set, ask for it, show current set hostname and keep if empty
if [ -z "$HOSTNAME" ]; then
    printf " *** Enter hostname (current: '$(hostname)', press enter to keep): "
    read HOSTNAME
    if [ -z "$HOSTNAME" ]; then
        printf " *** Keeping current hostname\n"
        HOSTNAME=$(hostname)
    fi
fi


##################################################################
# Stage 0                                                        #
# -------                                                        #
# When running this script as root on Arch it will first install #
# the arch_base script.                                          #
##################################################################
printf "Bakhuis system installer (v$INSTALLER_VERSION)\n===================================\n"

# Location of the install scripts
MAIN_INSTALL_SCRIPTS=$DOTFILES_ROOT/install_scripts

if [ "$(id -u)" -eq 0 ]; then
    printf "Stage 0\n-------\n"
    source $MAIN_INSTALL_SCRIPTS/arch_base.sh
    printf "\n\n *** To continue, run this script as \`$BASE_USER\`\n"
    exit 0
elif [ "$(whoami)" != "$BASE_USER" ]; then
    # Script is run as non-root user that is not $BASE_USER
    printf " *** ERROR: This script should be run as \`$BASE_USER\`\n"
    exit 1
fi


###################################################################
# Stage 1                                                         #
###################################################################
# The main stage runs as $BASE_USER and installs components. #
# Components do their own checks if they are already installed.   #
# The order of the components is important!                       #
###################################################################

# Returns whether the given command is executable or aliased.
_has() {
  return $( whence $1 >/dev/null )
}

# Check if on Mac or Arch
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    printf " *** Detected: Arch Linux\n"
    INSTALL_GUI_APPS=${INSTALL_GUI_APPS:-false}
elif [[ "$OSTYPE" == "darwin"* ]]; then
    printf " *** Detected: MacOs\n"
    INSTALL_GUI_APPS=${INSTALL_GUI_APPS:-true}
else
    printf "ERROR: Unknown OS\n"
    exit 1
fi


# pre-type sudo password
echo $BASE_PASSWORD | sudo -S echo "Sudo password set"

# 1-MAC: Homebrew (package manager)
source $MAIN_INSTALL_SCRIPTS/homebrew.sh

# 2-BOTH: Git (version control)
source $MAIN_INSTALL_SCRIPTS/git.sh

# 3-BOTH: Zsh (shell)
source $MAIN_INSTALL_SCRIPTS/zsh.sh

#
# # create directories if not exist
# mkdir -pv $HOME/.config/wezterm
# mkdir -pv $HOME/.ssh
#
#
# # install software check linux or mac
# if [[ "$OSTYPE" == "linux-gnu"* ]]; then
#     echo "Arch Linux"
#     
#     # install paru (needs to build using rust)
#     if ! _has paru; then
#         pacman -S --needed git base-devel && git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si && cd .. && rm -rf paru
#     fi
#     
#     # install packages
#     sudo pacman -S tmux neovim curl gawk fzf nodejs exa starship ripgrep fd neofetch
#     
#     # install GUI packages
#     if [[ "$INSTALL_GUI_APPS" == 1 ]]; then
#         echo "GUI used..."
#         sudo pacman -S wezterm ttf-firacode-nerd-font adobe-source-code-pro-fonts
#     fi
#
#     # install miniconda
#     wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
#     bash ~/miniconda.sh -b -p $HOME/miniconda
#     
# elif [[ "$OSTYPE" == "darwin"* ]]; then
#     echo "Mac OSX"
#     # install homebrew
#     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#     brew install tmux neovim curl gawk fzf nodejs exa starship fd
#     brew tap homebrew/cask-fonts
#     brew install --cask font-source-code-pro wezterm font-fira-mono-nerd-font
#     brew tap nidnogg/zeitfetch
#     brew install zeitfetch
#
#     # Install miniconda
#     curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o ~/miniconda.sh
#     bash ~/miniconda.sh -b -p $HOME/miniconda
# else
#     echo "Unknown OS"
# fi
#
# ############
# # symlinks #
# ############
#
# # nvim
# rm -rf $HOME/.config/nvim
# ln -s $HOME/dotfiles/nvim $HOME/.config/nvim
#
# rm -f $HOME/.alacritty.yml $HOME/.config/alacritty/alacritty.yml
# ln -s $HOME/dotfiles/alacritty/alacritty.yml.macbook $HOME/.config/alacritty/alacritty.yml
# rm -f $HOME/.wezterm.lua $HOME/.config/wezterm/wezterm.lua
# ln -s $HOME/dotfiles/wezterm/wezterm.lua $HOME/.config/wezterm/wezterm.lua
#
# rm -f $HOME/.tmux.conf
# ln -s $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf
#
# rm -f $HOME/.ssh/config
# ln -s ~/dotfiles/ssh/config ~/.ssh/config
#

