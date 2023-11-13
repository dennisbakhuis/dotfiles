#!/bin/zsh
#######
# Git #
#######

# Settings
GIT_ENABLED=${NEOVIM_ENABLED:-"true"}


# Init Git
if [ "$GIT_ENABLED" = "true" ]; then
    if command -v git &> /dev/null; then

        # Aliases
        alias g='git'
        alias ga='git add'
        alias gaa='git add --all'
        alias gc='git commit -v'
        alias gs='git status'
        alias gr='git reset'
    fi
fi
