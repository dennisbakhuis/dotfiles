#!/bin/sh
#########################################
# Script to install Visual Studio Code  #
#                                       #
# VSCode is a popular code editor       #
# with extensive extension support.     #
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
    printf " *** Skipping Visual Studio Code (not on macOS)...\n"
    exit 0
fi

# Install Visual Studio Code
if [ ! -d "/Applications/Visual Studio Code.app" ]; then
    printf " *** Installing Visual Studio Code...\n"
    NONINTERACTIVE=1 brew install --cask visual-studio-code
    printf " *** Visual Studio Code installed successfully\n"
else
    printf " *** Visual Studio Code is already installed...\n"
fi

# Check if DOTFILES_ROOT is set
if [ -z "$DOTFILES_ROOT" ]; then
    printf " *** ERROR(VS Code): DOTFILES_ROOT is not set, exiting...\n"
    exit 1
fi

# VS Code config directory on macOS
VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"

# Ensure VS Code config directory exists
mkdir -p "$VSCODE_CONFIG_DIR"

# Backup existing settings.json if it exists and is not a symlink
if [ -f "$VSCODE_CONFIG_DIR/settings.json" ] && [ ! -L "$VSCODE_CONFIG_DIR/settings.json" ]; then
    BACKUP_FILE="$VSCODE_CONFIG_DIR/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
    printf " *** Backing up existing settings.json to $BACKUP_FILE...\n"
    mv "$VSCODE_CONFIG_DIR/settings.json" "$BACKUP_FILE"
fi

# Backup existing keybindings.json if it exists and is not a symlink
if [ -f "$VSCODE_CONFIG_DIR/keybindings.json" ] && [ ! -L "$VSCODE_CONFIG_DIR/keybindings.json" ]; then
    BACKUP_FILE="$VSCODE_CONFIG_DIR/keybindings.json.backup.$(date +%Y%m%d_%H%M%S)"
    printf " *** Backing up existing keybindings.json to $BACKUP_FILE...\n"
    mv "$VSCODE_CONFIG_DIR/keybindings.json" "$BACKUP_FILE"
fi

# Remove old symlinks if they exist
rm -f "$VSCODE_CONFIG_DIR/settings.json"
rm -f "$VSCODE_CONFIG_DIR/keybindings.json"

# Link VS Code configuration files
ln -sf "$DOTFILES_ROOT/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
ln -sf "$DOTFILES_ROOT/vscode/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"

printf " *** Visual Studio Code configuration linked successfully!\n"