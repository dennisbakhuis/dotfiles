#!/bin/bash
#########################################
# Script to install fetch               #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-28                      #
#########################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

########
# Main #
########

# Install fastfetch on all platforms
if [ ! -x "$(command -v fastfetch)" ]; then
    printf " *** Installing Fastfetch on $OS_TYPE...\n"
    if [ "$OS_TYPE" = "macos" ]; then
        NONINTERACTIVE=1 brew install fastfetch
    else
        eval $PKG_INSTALL_NONINTERACTIVE fastfetch
    fi
else
    printf " *** Fastfetch is already installed...\n"
fi

# Symlink fastfetch config
FASTFETCH_CONFIG_DIR="$HOME/.config/fastfetch"
mkdir -p "$FASTFETCH_CONFIG_DIR"
if [ -e "$FASTFETCH_CONFIG_DIR/config.jsonc" ] && [ ! -L "$FASTFETCH_CONFIG_DIR/config.jsonc" ]; then
    mv "$FASTFETCH_CONFIG_DIR/config.jsonc" "$FASTFETCH_CONFIG_DIR/config.jsonc.backup.$(date +%Y%m%d_%H%M%S)"
fi
ln -sf "$DOTFILES_ROOT/fastfetch/config.jsonc" "$FASTFETCH_CONFIG_DIR/config.jsonc"
printf " *** Linked fastfetch config\n"
