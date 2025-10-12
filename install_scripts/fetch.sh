#!/bin/sh
#########################################
# Script to install fetch               #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-28                      #
#########################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

########
# Main #
########

# Install different fetch tools based on OS
if [ "$OS_TYPE" = "macos" ]; then
    if [ ! -x "$(command -v zeitfetch)" ]; then
        printf " *** Installing Zeitfetch on macOS...\n"
        NONINTERACTIVE=1 brew tap nidnogg/zeitfetch
        NONINTERACTIVE=1 brew install zeitfetch
    else
        printf " *** Zeitfetch is already installed...\n"
    fi
else
    # Linux (Arch/Ubuntu)
    if [ ! -x "$(command -v neofetch)" ]; then
        printf " *** Installing Neofetch on $OS_TYPE...\n"
        eval $PKG_INSTALL_NONINTERACTIVE neofetch
    else
        printf " *** Neofetch is already installed...\n"
    fi
fi