#!/bin/bash
######################################
# Script to check Homebrew           #
#                                    #
# Homebrew is a prerequisite and     #
# should already be installed.       #
#                                    #
# Author: Dennis Bakhuis             #
# Date: 2023-11-12                   #
######################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

########
# Main #
########

# Only if on macOS (Homebrew should already be installed as prerequisite)
if [ "$OS_TYPE" = "macos" ]; then
    # Homebrew should already be installed (checked in main install.sh)
    printf " *** Homebrew is available...\n"
else
    printf " *** Skipping Homebrew check on $OS_TYPE...\n"
fi
