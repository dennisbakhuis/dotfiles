#!/bin/sh
#########################################
# Test Homebrew install script          #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-25                      #
#########################################

TESTS_FOR="Homebrew"
NUM_ERRORS=0
HOMEBREW_INSTALL=${HOMEBREW_INSTALL:-true}


if [ "$HOMEBREW_INSTALL" = true ]; then

    # Only run when on Mac
    if [ "$(uname)" == "Darwin" ]; then
    
        # test if homebrew is installed
        if ! command -v brew > /dev/null; then
            echo "ERROR($TESTS_FOR): homebrew is not installed"
            NUM_ERRORS=$((NUM_ERRORS+1))
        fi
    
        ###############
    
        if [ $NUM_ERRORS -eq 0 ]; then
            echo " *** $TESTS_FOR: tests passed!"
        else
            echo " *** ERROR($TESTS_FOR): $NUM_ERRORS tests failed"
            exit 1
        fi
    
    else
        echo " *** $TESTS_FOR: tests skipped as not on Mac"
    fi

fi
