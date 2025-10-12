#!/bin/sh
#########################################
# Script to install OrbStack           #
#                                       #
# OrbStack is a fast, lightweight       #
# Docker and Linux container runtime    #
# for macOS.                            #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2025-10-11                      #
#########################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

########
# Main #
########

# Only run on macOS
if [ "$OS_TYPE" != "macos" ]; then
    printf " *** Skipping OrbStack (not on macOS)...\n"
    exit 0
fi

# Install OrbStack
if [ ! -x "$(command -v orbstack)" ]; then
    printf " *** Installing OrbStack...\n"
    NONINTERACTIVE=1 brew install --cask orbstack
    printf " *** OrbStack installed successfully\n"
else
    printf " *** OrbStack is already installed...\n"
fi