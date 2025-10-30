#!/bin/sh
#########################################
# Script to install uv                  #
#                                       #
# uv is a fast Python package and       #
# project manager written in Rust.      #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2025-10-10                      #
#########################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

########
# Main #
########

# Check if uv is already installed
if [ ! -x "$(command -v uv)" ]; then
    printf " *** Installing uv on $OS_TYPE...\n"

    if [ "$OS_TYPE" = "macos" ]; then
        # Install uv using Homebrew on macOS
        NONINTERACTIVE=1 brew install uv
    else
        # Install uv using the official installer on Linux
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi

    printf " *** uv installed successfully...\n"
else
    printf " *** uv is already installed...\n"
fi

# Create config directory and symlink uv config
printf " *** Setting up uv configuration...\n"
mkdir -p ~/.config/uv
ln -sf $DOTFILES_ROOT/uv/uv.toml ~/.config/uv/uv.toml
printf " *** uv configuration linked successfully...\n"