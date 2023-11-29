#!/bin/sh
#########################################
# Script to install Wezterm             #
#                                       #
# Including Nerd fonts:                 #
#  - Fira Code font                     #
#  - Adobde Source Code Pro font        #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-28                      #
#########################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

############
# Settings #
############
WEZTERM_INSTALL=${WEZTERM_INSTALL:-true}


########
# Main #
########

if [ "$WEZTERM_INSTALL" = true ]; then

    # install wezterm if not yet installed
    if [ ! -x "$(command -v wezterm)" ]; then
        printf " *** Installing Wezterm...\n"

        if [ "$(uname)" = "Darwin" ]; then
            # Mac noninteractive install
            NONINTERACTIVE=1 brew tap homebrew/cask-fonts
            NONINTERACTIVE=1 brew install --cask font-source-code-pro wezterm font-fira-mono-nerd-font

        elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
            # Arch
            sudo pacman -S --noconfirm wezterm ttf-firacode-nerd-font adobe-source-code-pro-fonts

        else
            echo "Unsupported OS, exiting..."
            exit 1
        fi
    else
        printf " *** Wezterm is already installed...\n"
    fi

    # Relink wezterm config
    rm -rf $HOME/.config/wezterm $HOME/.wezterm.lua
    mkdir -pv $HOME/.config/wezterm
    ln -s $DOTFILES_ROOT/wezterm/wezterm.lua $HOME/.config/wezterm/wezterm.lua

fi
