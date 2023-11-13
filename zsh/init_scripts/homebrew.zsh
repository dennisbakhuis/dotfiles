#!/bin/zsh
############
# Homebrew #
############

# Settings
HOMEBREW_ENABLED=${HOMEBREW_ENABLED:-"true"}
HOMEBREW_EXECUTABLE=${HOMEBREW_EXECUTABLE:-"/opt/homebrew/bin/brew"}


# Check if starship is installed else install it
if [ "$HOMEBREW_ENABLED" = "true" ]; then
    if [ -f "$HOMEBREW_EXECUTABLE" ]; then
        eval "$($HOMEBREW_EXECUTABLE shellenv)"
    fi
fi
