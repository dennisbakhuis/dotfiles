#######
# Git #
#######
# Git aliases and functions. This script will check if Git is installed
# and if it is, it will create aliases and functions.


# Settings
ZSH_INIT_GIT=${ZSH_INIT_GIT:-"true"}
PRIORITY=200


# Init Git
if [ "$ZSH_INIT_GIT" = "true" ]; then
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
