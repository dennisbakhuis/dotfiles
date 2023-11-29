#!/bin/sh
#########################################
# Test Neovim install script            #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-25                      #
#########################################

TESTS_FOR="Neovim"
NUM_ERRORS=0
NEOVIM_INSTALL=${NEOVIM_INSTALL:-true}


###############

if [ "$NEOVIM_INSTALL" = true ]; then

    # test if neovim is installed
    if ! command -v nvim > /dev/null; then
        printf " *** ERROR($TESTS_FOR): neovim is not installed.\n"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    # test if neovim config link is the same as $DOTFILES_ROOT/nvim
    NEOVIM_CONFIG_LINK=$(readlink $HOME/.config/nvim)
    if [ "$NEOVIM_CONFIG_LINK" != "$DOTFILES_ROOT/nvim" ]; then
        printf " *** ERROR($TESTS_FOR): neovim config is not linked.\n"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    ###############
    
    if [ $NUM_ERRORS -eq 0 ]; then
        printf " *** $TESTS_FOR: tests passed!\n"
    else
        printf " *** ERROR($TESTS_FOR): $NUM_ERRORS tests failed.\n"
        exit 1
    fi
fi    
