#!/bin/sh
#########################################
# Script to install SSH                 #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-13                      #
#########################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

########
# Main #
########

# install ssh if not yet installed
if [ ! -x "$(command -v ssh)" ]; then
    printf " *** Installing SSH on $OS_TYPE...\n"

    if [ "$OS_TYPE" = "macos" ]; then
        # macOS (usually pre-installed, but just in case)
        NONINTERACTIVE=1 brew install openssh
    elif [ "$OS_TYPE" = "arch" ]; then
        # Arch Linux
        eval $PKG_INSTALL_NONINTERACTIVE openssh
    elif [ "$OS_TYPE" = "ubuntu" ]; then
        # Ubuntu/Debian
        eval $PKG_INSTALL_NONINTERACTIVE openssh-client openssh-server
    else
        printf " *** ERROR: Unsupported OS type: $OS_TYPE\n"
        exit 1
    fi
else
    printf " *** SSH is already installed...\n"
fi

# Check if DOTFILES_ROOT is set
if [ -z "$DOTFILES_ROOT" ]; then
    printf " *** ERROR(SSH): DOTFILES_ROOT is not set, exiting...\n"
    exit 1
fi

# Ensure .ssh directory exists
mkdir -p $HOME/.ssh

# Backup existing ssh config if it exists and is not a symlink
if [ -f "$HOME/.ssh/config" ] && [ ! -L "$HOME/.ssh/config" ]; then
    BACKUP_FILE="$HOME/.ssh/config.backup.$(date +%Y%m%d_%H%M%S)"
    printf " *** Backing up existing ssh config to $BACKUP_FILE...\n"
    mv "$HOME/.ssh/config" "$BACKUP_FILE"
fi

# Remove old symlink if it exists
rm -f $HOME/.ssh/config

# Link ssh configuration
ln -sf $DOTFILES_ROOT/ssh/config $HOME/.ssh/config