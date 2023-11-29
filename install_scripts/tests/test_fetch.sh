#!/bin/sh
#########################################
# Test fetch install script             #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-28                      #
#########################################

TESTS_FOR="fetch"
NUM_ERRORS=0
FETCH_INSTALL=${FETCH_INSTALL:-true}


###############

# check if FETCH_INSTALL is set to true
if [ "$FETCH_INSTALL" = true ]; then
    
    # if on mac check if zeitfetch is installed, if on arch neofetch
    if [ "$(uname)" == "Darwin" ]; then
        # test if zeitfetch is installed
        if ! command -v zeitfetch > /dev/null; then
            printf " *** ERROR($TESTS_FOR): zeitfetch is not installed.\n"
            NUM_ERRORS=$((NUM_ERRORS+1))
        fi
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # test if neofetch is installed
        if ! command -v neofetch > /dev/null; then
            printf " *** ERROR($TESTS_FOR): neofetch is not installed.\n"
            NUM_ERRORS=$((NUM_ERRORS+1))
        fi
    fi
    
    ###############
    
    if [ $NUM_ERRORS -eq 0 ]; then
        printf " *** $TESTS_FOR: tests passed!\n"
    else
        printf " *** ERROR($TESTS_FOR): $NUM_ERRORS tests failed.\n"
        exit 1
    fi
fi
