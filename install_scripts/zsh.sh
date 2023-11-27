#!/bin/sh
######################################
# Script to zsh                      #
#                                    #
# Also install packages:             #
#  - starship                        #
#  - exa                             #
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
ZSH_INSTALL=${ZSH_INSTALL:-true}  # Install Zsh if not installed (default: true)


########
# Main #
########

# Install Zsh
if [ "$ZSH_INSTALL" = true ]; then
    printf " *** Installing Zsh...\n"

    # check if zsh is installed
    if [ ! -x "$(command -v zsh)" ]; then
        # check if on Mac
        if [ "$(uname)" == "Darwin" ]; then
            # check if homebrew is installed
            if [ ! -x "$(command -v brew)" ]; then
                printf " *** ERROR: Installing zsh - homebrew is not installed, exiting...\n"
                exit 1
            fi
            NONINTERACTIVE=1 brew install zsh starship exa

        elif [ "$(uname)" == "Linux" ]; then
            sudo pacman -S --noconfirm zsh exa

            # check if on 32bit arm else regular install
            if [ "$(uname -m)" == "armv7l" ]; then
                # 32bit arm (Raspberry Pi <4)
                sh -c "$(curl -fsSL https://starship.rs/install.sh)" -y -f
            else 
                sudo pacman -S --noconfirm starship
            fi

        else
            printf " *** ERROR: Installing zsh - unknown OS, exiting...\n"
            exit 1
        fi
    else
        printf " *** Zsh is already installed...\n"
    fi

    # check if DOTFILES_ROOT is set
    if [ -z "$DOTFILES_ROOT" ]; then
        printf " *** ERROR(Zsh): DOTFILES_ROOT is not set, exiting...\n"
        exit 1
    fi

    # check if HOSTNAME is set
    if [ -z "$HOSTNAME" ]; then
        printf " *** ERROR(Zsh): HOSTNAME is not set, exiting...\n"
        exit 1
    fi

    # remove previous links, folders, cache.
    rm -f $HOME/.zshrc
    rm -rf $HOME/.zfunc
    rm -rf $HOME/.cache/zsh
    rm -rf $HOME/.config/zsh
    rm -rf $HOME/.zplug

    # create new folders and links
    mkdir -pv $HOME/.cache/zsh
    mkdir -pv $HOME/.zfunc

    # Link or create zshrc config
    export ZSH_CONFIG_NAME="zshrc.$HOSTNAME"
    if ! [[ -f $DOTFILES_ROOT/zsh/$ZSH_CONFIG_NAME ]]; then
        cp $DOTFILES_ROOT/zsh/zshrc.base $DOTFILES_ROOT/zsh/$ZSH_CONFIG_NAME
        echo "export DOTFILES_ROOT=$DOTFILES_ROOT" >> "$DOTFILES_ROOT/zsh/$ZSH_CONFIG_NAME"
        echo "" >> "$DOTFILES_ROOT/zsh/$ZSH_CONFIG_NAME"
        echo "# Source shared zshrc config" >> "$DOTFILES_ROOT/zsh/$ZSH_CONFIG_NAME"
        echo "source $DOTFILES_ROOT/zsh/zshrc.default" >> "$DOTFILES_ROOT/zsh/$ZSH_CONFIG_NAME"
        echo "" >> "$DOTFILES_ROOT/zsh/$ZSH_CONFIG_NAME"
        echo "# After this line added by other porgrams" >> "$DOTFILES_ROOT/zsh/$ZSH_CONFIG_NAME"
    fi
    ln -s $DOTFILES_ROOT/zsh/$ZSH_CONFIG_NAME $HOME/.zshrc

    # Link antidote plugins file
    ln -s $DOTFILES_ROOT/zsh/zsh_plugins.txt $HOME/.zsh_plugins.txt

    # Set default shell to zsh
    printf " *** Setting default shell to zsh...\n"
    sudo usermod --shell /usr/bin/zsh dennis

fi

