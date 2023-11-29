#!/bin/sh
#########################################
# Test ssh install script               #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-28                      #
#########################################

TESTS_FOR="ssh"
NUM_ERRORS=0
SSH_INSTALL=${SSH_INSTALL:-true}


###############

if [ "$SSH_INSTALL" = true ]; then

    # test if ssh is installed
    if ! command -v ssh > /dev/null; then
        printf " *** ERROR($TESTS_FOR): ssh is not installed.\n"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    # test if ssh config link is the same as $DOTFILES_ROOT/ssh/config
    SSH_CONFIG_LINK=$(readlink $HOME/.ssh/config)
    if [ "$SSH_CONFIG_LINK" != "$DOTFILES_ROOT/ssh/config" ]; then
        printf " *** ERROR($TESTS_FOR): ssh config is not linked.\n"
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
