#!/bin/sh
#########################################
# Test Zsh install script               #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-27                      #
#########################################

TESTS_FOR="Zsh"
NUM_ERRORS=0

###############

# test if zsh is installed
if ! command -v zsh > /dev/null; then
    printf "ERROR($TESTS_FOR): zsh is not installed.\n"
    NUM_ERRORS=$((NUM_ERRORS+1))
fi

# test if starship is installed
if ! command -v starship > /dev/null; then
    printf "ERROR($TESTS_FOR): starship is not installed.\n"
    NUM_ERRORS=$((NUM_ERRORS+1))
fi

# check if zshrc is linked
if [ ! -f $HOME/.zshrc ]; then
    printf "ERROR($TESTS_FOR): zshrc is not copied.\n"
    NUM_ERRORS=$((NUM_ERRORS+1))
fi

# extract DOTFILES_ROOT from .zshrc
FOUND_DOTFILES_ROOT=$(grep DOTFILES_ROOT= $HOME/.zshrc | cut -d "=" -f2)
if [ ! -f $FOUND_DOTFILES_ROOT/zsh/zshrc.default ]; then
    printf "ERROR($TESTS_FOR): DOTFILES_ROOT is not set correctly in zshrc.\n"
    NUM_ERRORS=$((NUM_ERRORS+1))
fi

# check if antidote plugins file is linked
if [ ! -f $HOME/.zsh_plugins.txt ]; then
    printf "ERROR($TESTS_FOR): antidote plugins is not copied.\n"
    NUM_ERRORS=$((NUM_ERRORS+1))
fi

# check if current user hase zsh as login shell
if [ "$(uname)" == "Darwin" ]; then
    CURRENT_SHELL=$(dscl . -read ~/ UserShell | gsed 's/UserShell: //')
else
    CURRENT_SHELL=$(grep ^$(id -un): /etc/passwd | cut -d : -f 7-)
fi
if [ "$CURRENT_SHELL" != "/bin/zsh" ] && [ "$CURRENT_SHELL" != "/usr/bin/zsh" ]; then
    printf "ERROR($TESTS_FOR): zsh is not the default shell.\n"
    NUM_ERRORS=$((NUM_ERRORS+1))
fi

# check if exa is installed
if ! command -v exa > /dev/null; then
    printf "ERROR($TESTS_FOR): exa is not installed.\n"
    NUM_ERRORS=$((NUM_ERRORS+1))
fi

###############

if [ $NUM_ERRORS -eq 0 ]; then
    printf " *** $TESTS_FOR: tests passed!.\n"
else
    printf " *** ERROR($TESTS_FOR): $NUM_ERRORS tests failed.\n"
    exit 1
fi

