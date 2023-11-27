#!/bin/zsh
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


################
# Prerequisits #
################

# check if zsh is the current shell
if [ "$(basename $SHELL)" != "zsh" ]; then
    echo "zsh is not the current shell, exiting..."
    exit 1
fi

# check if fzf is already installed
if [ -x "$(command -v fzf)" ]; then
    echo "fzf is already installed, exiting..."
    exit 0 
fi


########
# Main #
########

# Install fzf on Mac or Arch Linux
if [ "$FZF_INSTALL" == "true" ]; then
    if [ "$(uname)" == "Darwin" ]; then
        echo "Installing fzf on Mac..."
        brew install fzf ripgrep bat fd
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        echo "Installing fzf on Arch..."
        pacman -S fzf ripgrep bat fd
    else
        echo "OS not supported, exiting..."
        exit 1
    fi
fi
