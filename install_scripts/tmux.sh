#!/bin/sh
######################################
# Script to Tmux                     #
#                                    #
# Author: Dennis Bakhuis             #
# Date: 2024-02-14                   #
######################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi


########
# Main #
########

# Only install tmux if not yet installed
if [ ! -x "$(command -v tmux)" ]; then
    printf " *** Installing Tmux on $OS_TYPE...\n"
    eval $PKG_INSTALL_NONINTERACTIVE tmux
else
    printf " *** Tmux is already installed..."
fi

# Check if DOTFILES_ROOT is set
if [ -z "$DOTFILES_ROOT" ]; then
    printf " *** ERROR(Tmux): DOTFILES_ROOT is not set, exiting...\n"
    exit 1
fi

# Backup existing tmux config if it exists and is not a symlink
if [ -f "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
    BACKUP_FILE="$HOME/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)"
    printf " *** Backing up existing .tmux.conf to $BACKUP_FILE...\n"
    mv "$HOME/.tmux.conf" "$BACKUP_FILE"
fi

# Remove old symlink if it exists
rm -f $HOME/.tmux.conf

# Link tmux configuration
ln -sf $DOTFILES_ROOT/tmux/tmux.conf $HOME/.tmux.conf
