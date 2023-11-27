#!/bin/sh
######################################
# Script to Git                      #
#                                    #
# Author: Dennis Bakhuis             #
# Date: 2023-11-25                   #
######################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

############
# Settings #
############
GIT_INSTALL=${GIT_INSTALL:-true}  # Install Git if not installed (default: true)


########
# Main #
########

# Only install git if not yet installed
if [ "$GIT_INSTALL" = true ]; then
    if [ ! -x "$(command -v git)" ]; then
        echo " *** Installing Git..."

        # check if on Mac
        if [ "$(uname)" == "Darwin" ]; then

            # check if homebrew is installed
            if [ ! -x "$(command -v brew)" ]; then
                echo " *** ERROR: Installing git - homebrew is not installed, exiting..."
                exit 1
            fi

            NONINTERACTIVE=1 brew install git
        elif [ "$(uname)" == "Linux" ]; then
            sudo pacman -S --noconfirm git
        else
            echo " *** ERROR: Installing git - unknown OS, exiting..."
            exit 1
        fi
    else
        echo " *** Git is already installed..."
    fi

    # Check if DOTFILES_ROOT is set
    if [ -z "$DOTFILES_ROOT" ]; then
        echo " *** ERROR(Git): DOTFILES_ROOT is not set, exiting..."
        exit 1
    fi

    # Relink/copy gitignore and gitconfig
    # gitconfig is copied as path to gitignore is different on each machine
    rm -f $HOME/.ignore
    rm -f $HOME/.gitconfig
    rm -f $HOME/.gitignore
    ln -s $DOTFILES_ROOT/git/gitignore $HOME/.ignore
    cp $DOTFILES_ROOT/git/gitconfig $HOME/.gitconfig

    # set global gitignore as it is a new copy
    echo " *** Setting global gitignore..."
    git config --global core.excludesfile $DOTFILES_ROOT/git/gitignore

fi
