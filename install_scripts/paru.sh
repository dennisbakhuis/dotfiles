#!/bin/sh
######################################
# Script to install Paru             #
#                                    #
# Installs requiremented packages:   #
#  - rustup                          #
#                                    #
# Author: Dennis Bakhuis             #
# Date: 2023-11-28                   #
######################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi


############
# Settings #
############
PARU_INSTALL=${PARU_INSTALL:-true}  # Install Paru if not installed (default: true)


########
# Main #
########

# only install if on arch
if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

    if [ "$PARU_INSTALL" = true ]; then
        # check if paru is already installed
        if [ ! -x "$(command -v paru)" ]; then
            printf " *** Installing Paru...\n"

            # rust is required for paru building
            sudo pacman -S --noconfirm rustup
            rustup default stable

            # build paru
            git clone https://aur.archlinux.org/paru.git $HOME/.local/src/paru
            cd $HOME/.local/src/paru

            # makepkg -si --noconfirm
            cd $HOME
            rm -rf $HOME/.local/src/paru
                    
        else
            printf " *** Paru is already installed...\n"
        fi
    fi

fi
