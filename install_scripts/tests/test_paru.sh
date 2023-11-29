#!/bin/sh
#########################################
# Test paru install script              #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-28                      #
#########################################

TESTS_FOR="paru"
NUM_ERRORS=0
PARU_INSTALL=${PARU_INSTALL:-true}


if [ "$PARU_INSTALL" = true ]; then
    
    # only run when on Arch
    if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    
        # test if paru is installed
        if ! command -v paru > /dev/null; then
            echo "ERROR($TESTS_FOR): paru is not installed"
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
fi
