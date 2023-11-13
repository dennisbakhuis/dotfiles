#!/bin/zsh
############
# Starship #
############

# Installs when not installed and sets up starship prompt

# Settings
STARSHIP_ENABLED=${STARSHIP_ENABLED:-"true"}

# Check if starship is installed else install it
if [ "$STARSHIP_ENABLED" = "true" ]; then
    if command -v starship &> /dev/null; then
        eval "$(starship init zsh)"
    else
        # Check if mac or linux
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux (Arch)
            pacman -S starship
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            # Macbook
            brew install starship
        fi
        eval "$(starship init zsh)"
    fi
fi
