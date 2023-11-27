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

# Run main install script
source $MAIN_INSTALL_SCRIPT

# Run tests
# source $TEST_SCRIPTS/test_arch_base.sh        # Already tested in docker container creation
source $TEST_SCRIPTS/test_homebrew.sh           # Test homebrew install script
source $TEST_SCRIPTS/test_git.sh                # Test git install script

