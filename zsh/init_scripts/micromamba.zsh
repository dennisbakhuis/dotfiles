#!/bin/zsh
##############
# Micromamba #
##############

# Settings
MICROMAMBA_ENABLED=${MICROMAMBA_ENABLED:-"true"}
MICROMAMBA_PATH_NAME=${MICROMAMBA_PATH_NAME:-"micromamba"}

# Init Micromamba
if [ "$MICROMAMBA_ENABLED" = "true" ]; then
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

        # Jupyter Lab (keep as general alias as it could be available in multiple environments (or not))
        alias jl='jupyter lab --ip=0.0.0.0'
    fi
fi
