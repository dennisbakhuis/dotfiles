#!/bin/zsh
######################################
# Script to install Homebre          #
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
HOMEBREW_INSTALL=${HOMEBREW_INSTALL:-true}  # Install Homebrew if not installed (default: true)


################
# Prerequisits #
################

# check if zsh is the current shell
if [ "$(basename $SHELL)" != "zsh" ]; then
    echo "zsh is not the current shell, exiting..."
    exit 1
fi

# check if on mac
if [ "$(uname)" != "Darwin" ]; then
    echo "Not on mac, exiting..."
    exit 1
fi

# check if curl is installed
if [ ! -x "$(command -v curl)" ]; then
    echo "curl is not installed, exiting..."
    exit 1
fi

# check if homebrew is already installed
if [ -x "$(command -v brew)" ]; then
    echo "Homebrew is already installed, exiting..."
    exit 0
fi


########
# Main #
########

# Install Homebrew
if [ "$HOMEBREW_INSTALL" = true ]; then
    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

