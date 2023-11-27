#!/bin/sh
#########################################
# Script to test install script on Arch #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-22                      #
#########################################

# Folders
export DOTFILES_ROOT=/dotfiles
export MAIN_INSTALL_SCRIPT=$DOTFILES_ROOT/install.sh
export MAIN_INSTALL_SCRIPTS=$DOTFILES_ROOT/install_scripts
export TEST_SCRIPTS=$MAIN_INSTALL_SCRIPTS/tests

# Settings for cleanup
export REMOVE_ZSHRC_HOSTNAME=${REMOVE_ZSHRC_HOSTNAME:-false}

# Run main install script
source $MAIN_INSTALL_SCRIPT


#############
# Run tests #
#############

# source $TEST_SCRIPTS/test_arch_base.sh        # Already tested in docker container creation (need root)
source $TEST_SCRIPTS/test_homebrew.sh           # Test homebrew install script
source $TEST_SCRIPTS/test_git.sh                # Test git install script
source $TEST_SCRIPTS/test_zsh.sh                # Test zsh install script
source $TEST_SCRIPTS/test_fzf.sh                # Test fzf install script
source $TEST_SCRIPTS/test_neovim.sh             # Test neovim install script


####################
# Optional cleanup #
####################

# Remove zshrc.$HOSTNAME  as it is put in the git repo
if [ "$REMOVE_ZSHRC_HOSTNAME" = true ]; then
    printf " *** Removing $ZSH_CONFIG_NAME ...\n"
    rm -f $DOTFILES_ROOT/zsh/$ZSH_CONFIG_NAME
fi
