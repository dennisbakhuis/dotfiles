#!/bin/sh
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
MICROMAMBA_INSTALL=${MICROMAMBA_INSTALL:-true}


########
# Main #
########

# Install micromamba if not installed
if [ "$MICROMAMBA_INSTALL" = true ]; then

    if [ "$(uname)" = "Darwin" ]; then
        NONINTERACTIVE=1 brew install micromamba

    else
        mkdir -p $HOME/.local/bin
        curl -Ls https://micro.mamba.pm/api/micromamba/osx-arm64/latest | tar -xvj $HOME/.local/bin/micromamba

    fi

    # needed when future components need micromamba (e.g. poetry)
    export MAMBA_ROOT_PREFIX=$HOME/micromamba
    eval "$(micromamba shell hook --shell zsh)"

    # Create a symlink to condarc file to disable prompt change
    ln -s $HOME/dotfiles/conda/condarc $HOME/.condarc
fi

