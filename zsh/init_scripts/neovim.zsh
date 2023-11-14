##########
# Neovim #
##########
# Neovim is *the* text editor. This script will check if Neovim is
# installed and if it is, it will enable it.


# Settings
ZSH_INIT_NEOVIM=${ZSH_INIT_NEOVIM:-"true"}              # enable neovim
NEOVIM_PYTHON_ENV_NAME=${NEOVIM_PYTHON_ENV_NAME:-"vim"} # neovim python environment name
PRIORITY=150                                            # priority of this script


# Init Neovim
if [ "$ZSH_INIT_NEOVIM" = "true" ]; then
    if command -v nvim &> /dev/null; then
        if command -v conda &> /dev/null; then
            if { conda env list | grep "\b$NEOVIM_PYTHON_ENV_NAME\b"; } >/dev/null 2>&1; then
                export NEOVIM_PYTHON_ENV="$(conda env list | grep "$NEOVIM_PYTHON_ENV_NAME" | awk '{print $2}')/bin/python"
            else
                if [ "$ZSH_DEBUG_WARNING" = "true" ]; then
                    echo "WARNING: Neovim python environment not found. Please create a conda environment named '$NEOVIM_PYTHON_ENV_NAME' and install the python package `pynvim` and `debugpy` in it."
                fi
            fi
        else
            if [ "$ZSH_DEBUG_WARNING" = "true" ]; then
                echo "WARNING: Conda not found. Please install conda and create a conda environment named '$NEOVIM_PYTHON_ENV_NAME' and install the python package `pynvim` and `debugpy` in it."
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
fi
