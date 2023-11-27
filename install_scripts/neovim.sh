#!/bin/sh
#########################################
# Script to install Neovim              #
#                                       #
# Installs dependencies:                #
#  - nodejs                             #
#  - npm                                #
#  - cmake                              #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-13                      #
#########################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

############
# Settings #
############
NEOVIM_INSTALL=${NEOVIM_INSTALL:-true}      # Install Neovim


########
# Main #
########

if [ "$NEOVIM_INSTALL" = true ]; then

    # install neovim if not yet installed
    if [ ! -x "$(command -v nvim)" ]; then
        printf " *** Installing Neovim...\n"
        if [ "$(uname)" = "Darwin" ]; then
            # Mac noninteractive install
            NONINTERACTIVE=1 brew install neovim nodejs npm cmake
    
        elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
            # Arch
            sudo pacman -S --noconfirm neovim nodejs npm cmake

        else
            echo "Unsupported OS, exiting..."
            exit 1
        fi
    else
        printf " *** Neovim is already installed...\n"
    fi

    # Relink neovim lua config
    rm -rf $HOME/.config/nvim
    mkdir -p $HOME/.config
    ln -s $DOTFILES_ROOT/nvim $HOME/.config/nvim

fi
