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


############
# Settings #
############
TMUX_INSTALL=${TMUX_INSTALL:-true}  # Install Git if not installed (default: true)


########
# Main #
########

# Only install tmux if not yet installed
if [ "$TMUX_INSTALL" = true ]; then
    if [ ! -x "$(command -v tmux)" ]; then
        printf " *** Installing Tmux...\n"

        # check if on Mac
        if [ "$(uname)" == "Darwin" ]; then

            # check if homebrew is installed
            if [ ! -x "$(command -v brew)" ]; then
                printf " *** ERROR: Installing Tmux - homebrew is not installed, exiting...\n"
                exit 1
            fi

            NONINTERACTIVE=1 brew install tmux

        elif [ "$(uname)" == "Linux" ]; then
            sudo pacman -S --noconfirm tmux
        else
            printf " *** ERROR: Installing Tmux - unknown OS, exiting...\n"
            exit 1
        fi
    else
        printf " *** Tmux is already installed..."
    fi

    # Check if DOTFILES_ROOT is set
    if [ -z "$DOTFILES_ROOT" ]; then
        printf " *** ERROR(Tmux): DOTFILES_ROOT is not set, exiting...\n"
        exit 1
    fi

    # Relink/copy gitignore and gitconfig
    rm -rf $HOME/.tmux.conf
    ln -s $DOTFILES_ROOT/tmux/tmux.conf $HOME/.tmux.conf

fi
