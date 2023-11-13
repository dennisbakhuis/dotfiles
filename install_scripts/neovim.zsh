#!/bin/zsh
#########################################
# Script to install Neovim              #
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


################
# Prerequisits #
################

# check if zsh is the current shell
if [ "$(basename $SHELL)" != "zsh" ]; then
    echo "zsh is not the current shell, exiting..."
    exit 1
fi

# check when on mac if brew is installed
if [ "$(uname)" = "Darwin" ]; then
    if ! command -v brew &> /dev/null; then
        echo "brew is not installed, exiting..."
        exit 1
    fi
fi

# check if neo vim is already installed
if command -v nvim &> /dev/null; then
    echo "Neovim is already installed, exiting..."
    exit 0
fi


########
# Main #
########

if [ "$NEOVIM_INSTALL" = true ]; then
    echo "Installing Neovim..."

    if [ "$(uname)" = "Darwin" ]; then
        # Mac 
    elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
        # Arch
    else
        echo "Unsupported OS, exiting..."
        exit 1
    fi
fi

