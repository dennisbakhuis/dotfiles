#!/bin/sh
######################################
# Script to install Homebrew         #
#                                    #
# Also install packages:             #
#  - gsed                            #
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
            printf "Installing Homebrew...\n"

            # check if curl is installed (default on mac)
            if [ ! -x "$(command -v curl)" ]; then
                printf " *** ERROR: Installing hombrew - curl is not installed, exiting...\n"
                exit 1
            fi

            printf "Installing Homebrew...\n"
            NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            # install gsed (MacOs uses BSD sed by default instead of GNU sed)
            printf " *** Installing gsed..."
            NONINTERACTIVE=1 brew install gnu-sed

        else
            printf " *** Homebrew is already installed...\n"

            # check if gsed is installed else install it
            if [ ! -x "$(command -v gsed)" ]; then
                printf " *** Installing gsed...\n"
                NONINTERACTIVE=1 brew install gnu-sed
            fi
        fi
    fi
fi
