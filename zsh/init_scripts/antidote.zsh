#!/bin/zsh
################
# ZSh Antidote #
################

# Settings
ANTIDOTE_ENABLED=${ANTIDOTE_ENABLED:-true}  # enable antidote
ANTIDOTE_ROOT=${ANTIDOTE_ROOT:-/antidote}   # antidote root directory

# Initialize Antidote if enabled
if [ "$ANTIDOTE_ENABLED" = true ]; then

    # Check if Antidote is already installed otherwise install it
    if [ ! -d "$ZSH_CONFIG_ROOT/$ANTIDOTE_ROOT" ]; then
        git clone --depth=1 https://github.com/mattmc3/antidote.git $ZSH_CONFIG_ROOT/$ANTIDOTE_ROOT
    fi

    # Source Antidote
    source "$ZSH_CONFIG_ROOT/$ANTIDOTE_ROOT/antidote.zsh"

    # initialize plugins statically with $ZSH_CONFIG_ROOT/zsh_plugins.txt
    antidote load "$ZSH_CONFIG_ROOT/zsh_plugins.txt"
fi
