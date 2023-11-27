#!/bin/sh
######################################
# Script to install fzf              #
#                                    #
# Including fd, ripgrep, bat         #
#                                    #
# Author: Dennis Bakhuis             #
# Date: 2023-11-12                   #
######################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi


############
# Settings #
############
FZF_INSTALL=${FZF_INSTALL:-true}  # Install FZF if not installed (default: true)


########
# Main #
########

# Install fzf on Mac or Arch Linux
if [ "$FZF_INSTALL" == "true" ]; then
    if [ "$(uname)" == "Darwin" ]; then
        printf " *** Installing fzf, bat, fd, and ripgrep on Mac...\n"
        brew install fzf ripgrep bat fd

    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        printf " *** Installing fzf, bat, fd, and ripgrep on Arch...\n"
        sudo pacman -S --noconfirm fzf ripgrep bat fd

    else
        printf " *** OS not supported, exiting...\n"
        exit 1

    fi
fi
