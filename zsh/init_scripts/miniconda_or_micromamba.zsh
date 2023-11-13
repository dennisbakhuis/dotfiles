#!/bin/zsh
###########################
# Miniconda or Micromamba #
###########################

# Check if command exists
_has() {
    type "$1" > /dev/null 2>&1
}


if _has micromamba; then
    # Micromamba
    export MAMBA_ROOT_PREFIX=$HOME/micromamba
    eval "$(micromamba shell hook --shell zsh)"

    # Alias micromamba to conda and set original conda to conda_original
    alias conda=micromamba
else
    # Miniconda
    export CONDA_ROOT_PREFIX=$HOME/miniconda3

    # check if miniconda is installed
    if [ ! -d "$CONDA_ROOT_PREFIX" ]; then
    
        __conda_setup="$($CONDA_ROOT_PREFIX/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "$CONDA_ROOT_PREFIX/etc/profile.d/conda.sh" ]; then
                . "$CONDA_ROOT_PREFIX/etc/profile.d/conda.sh"
            else
                export PATH="$CONDA_ROOT_PREFIX/bin:$PATH"
            fi
        fi
        unset __conda_setup
    
        # Check if conda command is available and remove prompt
        if _has conda; then
            # Make conda not change prompt
            conda config --set changeps1 False # stop (env) part from showing
        fi
    
        # When mamba is installed, alias it to conda and set conda to conda_original
        if _has mamba; then
            alias conda=mamba
            alias conda_original=$CONDA_ROOT_PREFIX/bin/conda
        fi
    fi
fi
