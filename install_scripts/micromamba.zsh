#!/bin/zsh
#########################################
# Script to install Micromamba          #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-12                      #
#########################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

############
# Settings #
############
MICROMAMBA_INSTALL=${MICROMAMBA_INSTALL:-true}  # Install Micromamba if not installed (default: true)


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

# check if micromamba is already installed
if command -v micromamba &> /dev/null; then
    echo "micromamba is already installed, exiting..."
    exit 0
fi


########
# Main #
########

# Install micromamba if not installed
if [ "$MICROMAMBA_INSTALL" = true ]; then
    if [ "$(uname)" = "Darwin" ]; then
        brew install micromamba
    else
        mkdir -p $HOME/.local/bin
        curl -Ls https://micro.mamba.pm/api/micromamba/osx-arm64/latest | tar -xvj $HOME/.local/bin/micromamba
    fi

    export MAMBA_ROOT_PREFIX=$HOME/micromamba
    eval "$(micromamba shell hook --shell zsh)"

    # Create a symlink to condarc file to disable prompt change
    ln -s $HOME/dotfiles/conda/condarc $HOME/.condarc
fi

