##############
# Micromamba #
##############
# Micromamba is a package manager for Python. This script will check
# if Micromamba is installed and if it is, it will enable it. 
# This script will also set some aliases for micromamba to make it
# a drop-in replacement for conda.


# Settings
ZSH_INIT_MICROMAMBA=${ZSH_INIT_MICROMAMBA:-"true"}          # enable micromamba
MICROMAMBA_PATH_NAME=${MICROMAMBA_PATH_NAME:-"micromamba"}  # micromamba path name
PRIORITY=100                                                # priority of this script


# Init Micromamba
if [ "$ZSH_INIT_MICROMAMBA" = "true" ]; then
    if command -v micromamba &> /dev/null; then
        # Micromamba
        export MAMBA_ROOT_PREFIX="$HOME/$MICROMAMBA_PATH_NAME"
    
        eval "$(micromamba shell hook --shell zsh)"
    
        # Alias micromamba to conda and set original conda to conda_original
        alias conda=micromamba

        # Aliases
        alias ca='conda activate'
        alias cl='conda env list'
        alias crm='conda env remove --name'

    fi
fi
