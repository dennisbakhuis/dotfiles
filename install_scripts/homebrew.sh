#!/bin/sh
######################################
# Script to install Homebrew         #
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


########
# Main #
########

# Only if on mac install Homebrew
if [ "$(uname)" == "Darwin" ]; then
    if [ "$HOMEBREW_INSTALL" = true ]; then

        # if homebrew is not yet installed
        if [ ! -x "$(command -v brew)" ]; then
            echo "Installing Homebrew..."

            # check if curl is installed (default on mac)
            if [ ! -x "$(command -v curl)" ]; then
                echo " *** ERROR: Installing hombrew - curl is not installed, exiting..."
                exit 1
            fi

            echo "Installing Homebrew..."
            NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            echo " *** Homebrew is already installed..."
        fi
    fi
fi
