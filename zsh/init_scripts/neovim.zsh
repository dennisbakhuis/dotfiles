#!/bin/zsh
##########
# Neovim #
##########

# Settings
NEOVIM_ENABLED=${NEOVIM_ENABLED:-"true"}
NEOVIM_PYTHON_ENV_NAME=${NEOVIM_PYTHON_ENV_NAME:-"vim"}


# Init Neovim
if [ "$NEOVIM_ENABLED" = "true" ]; then

    # Check if conda is installed and try to find the neovim environment
    if command -v conda &> /dev/null; then
        if { conda env list | grep "\b$NEOVIM_PYTHON_ENV_NAME\b"; } >/dev/null 2>&1; then
            export NEOVIM_PYTHON_ENV="$(conda env list | grep "$NEOVIM_PYTHON_ENV_NAME" | awk '{print $2}')/bin/python"
        else
            if [ "$DB_WARNING" = "true" ]; then
                echo "WARNING: Neovim python environment not found. Please create a conda environment named '$NEOVIM_PYTHON_ENV_NAME' and install the python package `pynvim` and `debugpy` in it."
            fi
        fi
    fi

    # Environment variables
    export EDITOR="nvim"
        
    # Aliases
    alias v="nvim"
    alias vi="nvim"
    alias vim="nvim"
    alias ez="nvim $HOME/dotfiles/zsh/zshrc.default"
    alias ea="nvim $HOME/dotfiles/zsh/aliases.zsh"

    # if vimdiff is installed add alias
    if command -v vimdiff &> /dev/null; then
        alias vimdiff="nvim -d"
    fi
fi
