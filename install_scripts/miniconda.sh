#!/bin/zsh
#########################################
# Script to install miniconda if needed #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-12                      #
#########################################
set -e  # Exit script immediately on first error.


############
# Settings #
############
MINICONDA_INSTALL=${MINICONDA_INSTALL:-true}                # Install miniconda if not installed (default: true)
MINICONDA_SETUP=${MINICONDA_SETUP:-true}                    # Setup miniconda (default: true)
MINICONDA_INSTALL_MAMBA=${MINICONDA_INSTALL_MAMBA:-true}    # Install mamba (default: true)
MINICONDA_REINSTALL=${MINICONDA_REINSTALL:-false}           # Reinstall miniconda if already installed (default: false)
MINICONDA_UNINSTALL=${MINICONDA_UNINSTALL:-false}           # Uninstall miniconda if already installed (default: false)

# Set miniconda install path
MINICONDA_INSTALL_PATH=${MINICONDA_INSTALL_PATH:-$HOME/miniconda3}

# Set miniconda package urls
MINICONDA_PACKAGE_URL_LINUX="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
MINICONDA_PACKAGE_URL_MAC="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"


################
# Prerequisits #
################

# check if wget is installed
if ! command -v wget &> /dev/null
then
    echo "wget could not be found, exiting..."
    exit 1
fi

# check if zsh is the current shell
if [ "$(basename $SHELL)" != "zsh" ]; then
    echo "zsh is not the current shell, exiting..."
    exit 1
fi

########
# Main #
########

# set miniconda path only if it is not set
if [ -z "$MINICONDA_PACKAGE_URL" ]; then
    if [ "$(uname)" = "Darwin" ]; then
        MINICONDA_PACKAGE_URL=$MINICONDA_PACKAGE_URL_MAC
    elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
        MINICONDA_PACKAGE_URL=$MINICONDA_PACKAGE_URL_LINUX
    else
        echo "Unsupported OS, exiting..."
        exit 1
    fi
fi

# Check if miniconda is already installed and if it needs to be uninstalled or reinstalled
if [ -d "$MINICONDA_INSTALL_PATH" ]; then
    if [ "$MINICONDA_UNINSTALL" = true ] || [ "$MINICONDA_REINSTALL" = true ; then
        echo "Removing miniconda..."
        rm -rf $MINICONDA_INSTALL_PATH
        rm -rf $HOME/.conda
        rm -rf $HOME/.condarc

        # Exit if only uninstalling
        if [ "$MINICONDA_UNINSTALL" = true ]; then
            echo "Miniconda uninstalled, exiting..."
            exit 0
        fi
    else
        echo "Miniconda already installed and MINICONDA_UNINSTALL and MINICONDA_REINSTALL are set to false, exiting..."
        exit 0
    fi
fi

# Install miniconda
if [ "$MINICONDA_INSTALL" = true ]; then
    echo "Miniconda not installed, installing..."
    wget -O miniconda.sh $MINICONDA_PACKAGE_URL
    bash miniconda.sh -b -p $MINICONDA_INSTALL_PATH
    rm miniconda.sh
else
    echo "Not installing miniconda because MINICONDA_INSTALL is set to false"
fi

# Setup miniconda
if [ "$MINICONDA_SETUP" = true ]; then
    echo "Setting up miniconda..."

    # Add miniconda to path
    eval "$($MINICONDA_INSTALL_PATH/bin/conda init.zsh hook)"

    # Stop conda from changing the prompt
    conda config --set changeps1 False
else
    echo "Not setting up miniconda because MINICONDA_SETUP is set to false"
fi

# Install mamba
if [ "$MINICONDA_INSTALL_MAMBA" = true ]; then
    echo "Installing mamba..."
    conda install -y mamba -c conda-forge
else
    echo "Not installing mamba because MINICONDA_INSTALL_MAMBA is set to false"
fi
