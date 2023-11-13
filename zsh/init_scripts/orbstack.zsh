#!/bin/zsh
############
# Homebrew #
############

# Settings
ORBSTACK_ENABLED=${ORBSTACK_ENABLED:-"true"}
ORBSTACK_SHELL_INIT=${ORBSTACK_SHELL_INIT:-"$HOME/.orbstack/shell/init.zsh"}


# Check if starship is installed else install it
if [ "$ORBSTACK_ENABLED" = "true" ]; then
    if [ -f "$ORBSTACK_SHELL_INIT" ]; then
        source "$ORBSTACK_SHELL_INIT" 2> /dev/null || :
    fi
fi
