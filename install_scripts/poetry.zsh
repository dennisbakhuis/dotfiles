#!/bin/zsh
#########################################
# Script to install Poetry              #
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
POETRY_INSTALL=${POETRY_INSTALL:-true}  # Install Poetry if not installed (default: true)
POETRY_ENV_NAME=${POETRY_ENV_NAME:-poetry}  # Name of the conda environment to install Poetry in (default: poetry)
POETRY_PYTHON_VERSION=${POETRY_PYTHON_VERSION:-3.12}  # Python version to use for Poetry (default: 3.12)


################
# Prerequisits #
################

# check if zsh is the current shell
if [ "$(basename $SHELL)" != "zsh" ]; then
    echo "zsh is not the current shell, exiting..."
    exit 1
fi

# check if a conda executable is available
if ! command -v conda &> /dev/null; then
    echo "conda is not available, exiting..."
    exit 1
fi

########
# Main #
########

# Install Poetry in a separate conda environment
if [ "$POETRY_INSTALL" = true ]; then
    conda create -n "$POETRY_ENV_NAME" python="$POETRY_PYTHON_VERSION"
    conda activate "$POETRY_ENV_NAME"
    pip install poetry
    conda deactivate
fi

