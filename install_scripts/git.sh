#!/bin/sh
######################################
# Script to configure Git            #
#                                    #
# Sets up Git configuration files    #
# and global gitignore               #
#                                    #
# Author: Dennis Bakhuis             #
# Date: 2023-11-25                   #
######################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi


########
# Main #
########

# Git should already be installed (prerequisite)
printf " *** Configuring Git...\n"

# Check if DOTFILES_ROOT is set
if [ -z "$DOTFILES_ROOT" ]; then
    printf " *** ERROR(Git): DOTFILES_ROOT is not set, exiting...\n"
    exit 1
fi

# Backup existing git configs if they exist and are not symlinks
if [ -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
    BACKUP_FILE="$HOME/.gitconfig.backup.$(date +%Y%m%d_%H%M%S)"
    printf " *** Backing up existing .gitconfig to $BACKUP_FILE...\n"
    mv "$HOME/.gitconfig" "$BACKUP_FILE"
fi

if [ -f "$HOME/.gitignore" ] && [ ! -L "$HOME/.gitignore" ]; then
    BACKUP_FILE="$HOME/.gitignore.backup.$(date +%Y%m%d_%H%M%S)"
    printf " *** Backing up existing .gitignore to $BACKUP_FILE...\n"
    mv "$HOME/.gitignore" "$BACKUP_FILE"
fi

# Remove old symlinks if they exist
rm -f $HOME/.ignore
rm -f $HOME/.gitignore

# Link gitignore and gitconfig
ln -sf $DOTFILES_ROOT/git/gitignore $HOME/.ignore
ln -sf $DOTFILES_ROOT/git/gitconfig $HOME/.gitconfig

# fd only use .gitignore when in a git repo; .fdignore is used always for fd
cp -f $DOTFILES_ROOT/git/gitignore $HOME/.fdignore

# set global gitignore
printf " *** Setting global gitignore...\n"
git config --global core.excludesfile $DOTFILES_ROOT/git/gitignore
