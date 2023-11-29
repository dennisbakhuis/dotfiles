#!/bin/sh
#########################################
# Test Fzf install script               #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-27                      #
#########################################

TESTS_FOR="fzf"
NUM_ERRORS=0
FZF_INSTALL=${FZF_INSTALL:-true}


if [ "$FZF_INSTALL" = true ]; then
    
    # test if fzf is installed
    if ! command -v fzf > /dev/null; then
        printf "ERROR($TESTS_FOR): fzf is not installed.\n"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    # test if bat is installed
    if ! command -v bat > /dev/null; then
        printf "ERROR($TESTS_FOR): bat is not installed.\n"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    # test if fd is installed
    if ! command -v fd > /dev/null; then
        printf "ERROR($TESTS_FOR): fd is not installed.\n"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    # test if ripgrep is installed
    if ! command -v rg > /dev/null; then
        printf "ERROR($TESTS_FOR): ripgrep is not installed.\n"
        NUM_ERRORS=$((NUM_ERRORS+1))
    fi
    
    ###############
    
    if [ $NUM_ERRORS -eq 0 ]; then
        echo " *** $TESTS_FOR: tests passed!"
    else
        echo " *** ERROR($TESTS_FOR): $NUM_ERRORS tests failed"
        exit 1
    fi

fi    
