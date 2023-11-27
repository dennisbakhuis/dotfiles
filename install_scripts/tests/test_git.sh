#!/bin/sh
#########################################
# Test Git install script               #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-25                      #
#########################################

TESTS_FOR="Git"
NUM_ERRORS=0

###############

# test if git is installed
if ! command -v git > /dev/null; then
    echo "ERROR($TESTS_FOR): git is not installed"
    NUM_ERRORS=$((NUM_ERRORS+1))
fi

# test if gitignore is linked
if [ ! -L $HOME/.ignore ]; then
    echo "ERROR($TESTS_FOR): gitignore is not linked"
    NUM_ERRORS=$((NUM_ERRORS+1))
fi

# test if is copied
if [ ! -f $HOME/.gitconfig ]; then
    echo "ERROR($TESTS_FOR): gitconfig is not copied"
    NUM_ERRORS=$((NUM_ERRORS+1))
fi

# test if global gitignore is set
if ! git config --global core.excludesfile > /dev/null; then
    echo "ERROR($TESTS_FOR): global gitignore is not set"
    NUM_ERRORS=$((NUM_ERRORS+1))
fi

###############

if [ $NUM_ERRORS -eq 0 ]; then
    echo " *** $TESTS_FOR: tests passed!"
else
    echo " *** ERROR($TESTS_FOR): $NUM_ERRORS tests failed"
    exit 1
fi

