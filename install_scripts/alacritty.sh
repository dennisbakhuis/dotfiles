#!/bin/sh
#########################################
# Script to install Alacritty           #
#                                       #
# Including Nerd fonts:                 #
#  - Fira Code font                     #
#  - Adobde Source Code Pro font        #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-02-14                      #
#########################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

############
# Settings #
############
ALACRITTY_INSTALL=${ALACRITTY_INSTALL:-true}


########
# Main #
########

if [ "$ALACRITTY_INSTALL" = true ]; then

    # install alacritty if not yet installed
    if [ ! -x "$(command -v alacritty)" ]; then
        printf " *** Installing Alacritty...\n"

        if [ "$(uname)" = "Darwin" ]; then
            # Mac noninteractive install
            NONINTERACTIVE=1 brew tap homebrew/cask-fonts
            NONINTERACTIVE=1 brew install --cask font-source-code-pro alacritty font-fira-mono-nerd-font

        elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
            # Arch
            sudo pacman -S --noconfirm alacritty ttf-firacode-nerd-font adobe-source-code-pro-fonts

        else
            echo "Unsupported OS, exiting..."
            exit 1
        fi
    else
        printf " *** Alacritty is already installed...\n"
    fi

    # Relink alacritty config
    rm -rf $HOME/.config/alacritty 
    mkdir -pv $HOME/.config/alacritty
    ln -s $DOTFILES_ROOT/alacritty/alacritty.toml $HOME/.config/alacritty/alacritty.toml
fi
