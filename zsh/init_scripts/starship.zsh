#!/bin/zsh
############
# Starship #
############
# Check if starship is installed else install it
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
