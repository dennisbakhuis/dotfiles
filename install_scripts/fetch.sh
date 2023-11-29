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

############
# Settings #
############
FETCH_INSTALL=${FETCH_INSTALL:-true}      # Install fetch


########
# Main #
########

if [ "$FETCH_INSTALL" = true ]; then

    # check if on mac or arch
    if [ "$(uname)" == "Darwin" ]; then
        printf " *** Installing Zeitfetch on Mac...\n"
        NONINTERACTIVE=1 brew tap nidnogg/zeitfetch
        NONINTERACTIVE=1 brew install zeitfetch

    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        printf " *** Installing Neofetch on Arch...\n"
        sudo pacman -S --noconfirm neofetch

    else
        printf " *** OS not supported, exiting...\n"
        exit 1

    fi

fi
