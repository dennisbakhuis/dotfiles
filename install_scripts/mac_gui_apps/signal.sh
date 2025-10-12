#!/bin/sh
#########################################
# Script to install Signal              #
#                                       #
# Signal is a privacy-focused           #
# messaging application.                #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2025-10-12                      #
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
    printf " *** Skipping Signal (not on macOS)...\n"
    exit 0
fi

# Install Signal
if [ ! -d "/Applications/Signal.app" ]; then
    printf " *** Installing Signal...\n"
    NONINTERACTIVE=1 brew install --cask signal
    printf " *** Signal installed successfully\n"
else
    printf " *** Signal is already installed...\n"
fi