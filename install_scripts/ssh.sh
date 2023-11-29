#!/bin/sh
#########################################
# Script to install Ssh                 #
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
SSH_INSTALL=${SSH_INSTALL:-true}      # Install Ssh


########
# Main #
########

if [ "$SSH_INSTALL" = true ]; then

    # install ssh if not yet installed
    if [ ! -x "$(command -v ssh)" ]; then
        printf " *** Installing ssh...\n"
        if [ "$(uname)" = "Darwin" ]; then
            # Mac noninteractive install
            NONINTERACTIVE=1 brew install openssh
    
        elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
            # Arch
            sudo pacman -S --noconfirm openssh

        else
            echo "Unsupported OS, exiting..."
            exit 1

        fi
    else
        printf " *** ssh is already installed...\n"
    fi

    # Relink ssh config
    mkdir -pv $HOME/.ssh
    rm -f $HOME/.ssh/config
    ln -s $DOTFILES_ROOT/ssh/config $HOME/.ssh/config

fi
