############################
# Exa (replacement for ls) #
############################
# Exa is a replacement for ls. This script will check if Exa is installed
# and if it is, it will create aliases.


# Settings
ZSH_INIT_EXA=${ZSH_INIT_EXA:-"true"}   # enable exa
PRIORITY=200                           # priority of this script


# Init Exa
if [ "$ZSH_INIT_EXA" = "true" ]; then
    if command -v exa &> /dev/null; then

        # Aliases
        alias ls='exa --icons'
        alias ll='ls -la'
    fi
fi
