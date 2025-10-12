#!/bin/sh
#########################################
# Script to install FlashSpace          #
#                                       #
# FlashSpace is a blazingly fast        #
# virtual workspace manager for macOS   #
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
    printf " *** Skipping FlashSpace (only available on macOS)...\n"
    exit 0
fi

# Check if FlashSpace is already installed
if [ -d "/Applications/FlashSpace.app" ]; then
    printf " *** FlashSpace is already installed...\n"
else
    printf " *** Installing FlashSpace...\n"
    NONINTERACTIVE=1 brew install --cask flashspace
    printf " *** FlashSpace installed successfully\n"
fi

# Check if DOTFILES_ROOT is set
if [ -z "$DOTFILES_ROOT" ]; then
    printf " *** ERROR(FlashSpace): DOTFILES_ROOT is not set, exiting...\n"
    exit 1
fi

# Ensure config directory exists
mkdir -p "$HOME/.config/flashspace"

# Backup existing profiles.toml if it exists and is not a symlink
if [ -f "$HOME/.config/flashspace/profiles.toml" ] && [ ! -L "$HOME/.config/flashspace/profiles.toml" ]; then
    BACKUP_FILE="$HOME/.config/flashspace/profiles.toml.backup.$(date +%Y%m%d_%H%M%S)"
    printf " *** Backing up existing FlashSpace profiles to $BACKUP_FILE...\n"
    mv "$HOME/.config/flashspace/profiles.toml" "$BACKUP_FILE"
fi

# Backup existing settings.toml if it exists and is not a symlink
if [ -f "$HOME/.config/flashspace/settings.toml" ] && [ ! -L "$HOME/.config/flashspace/settings.toml" ]; then
    BACKUP_FILE="$HOME/.config/flashspace/settings.toml.backup.$(date +%Y%m%d_%H%M%S)"
    printf " *** Backing up existing FlashSpace settings to $BACKUP_FILE...\n"
    mv "$HOME/.config/flashspace/settings.toml" "$BACKUP_FILE"
fi

# Remove old symlinks if they exist
rm -f "$HOME/.config/flashspace/profiles.toml"
rm -f "$HOME/.config/flashspace/settings.toml"

# Link FlashSpace configuration files
ln -sf "$DOTFILES_ROOT/flashspace/profiles.toml" "$HOME/.config/flashspace/profiles.toml"
ln -sf "$DOTFILES_ROOT/flashspace/settings.toml" "$HOME/.config/flashspace/settings.toml"

printf " *** FlashSpace configuration linked\n"