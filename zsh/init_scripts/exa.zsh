#!/bin/zsh
############################
# Exa (replacement for ls) #
############################

# Settings
EXA_ENABLED=${EXA_ENABLED:-"true"}


# Init Exa
if [ "$EXA_ENABLED" = "true" ]; then
    if command -v exa &> /dev/null; then

        # Aliases
        alias ls='exa --icons'
        alias ll='ls -la'
    fi
fi
