#!/bin/zsh
################
# ZSh Antidote #
################

# Settings
ANTIDOTE_ENABLED=${ANTIDOTE_ENABLED:-true}  # enable antidote
ANTIDOTE_ROOT=${ANTIDOTE_ROOT:-/antidote}   # antidote root directory

# Initialize Antidote if enabled
if [ "$ANTIDOTE_ENABLED" = true ]; then

    # Check if ZDOTDIR is set
    if [ -z "$ZDOTDIR" ]; then
        echo "ZDOTDIR is not set. Antidote is not initialized."
        return
    fi

    # Check if Antidote is already installed otherwise install it
    if [ ! -d "$ZDOTDIR/$ANTIDOTE_ROOT" ]; then
        git clone --depth=1 https://github.com/mattmc3/antidote.git $ZDOTDIR/$ANTIDOTE_ROOT
    fi

    # Source Antidote
    source "$ZDOTDIR/$ANTIDOTE_ROOT/antidote.zsh"

    # initialize plugins statically with $ZDOTDIR/zsh_plugins.txt
    antidote load "$ZDOTDIR/zsh_plugins.txt"
fi
