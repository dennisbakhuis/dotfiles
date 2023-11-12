#!/bin/zsh

# set -e if not set to stop script on error
if [ -z "$-echo" ]; then
    set -e
fi

###########################
# Miniconda or Micromamba #
###########################

if _has micromamba; then
    # Micromamba
    export MAMBA_ROOT_PREFIX=$HOME/micromamba
    eval "$(micromamba shell hook --shell zsh)"

    # Alias micromamba to conda and set original conda to conda_original
    alias conda=micromamba
else
    # Miniconda
    export MINICONDA_INSTALL_PATH=$HOME/miniconda3

    # check if miniconda is installed
    if [ ! -d "$MINICONDA_INSTALL_PATH" ]; then
    
        __conda_setup="$($MINICONDA_INSTALL_PATH/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "$MINICONDA_INSTALL_PATH/etc/profile.d/conda.sh" ]; then
                . "$MINICONDA_INSTALL_PATH/etc/profile.d/conda.sh"
            else
                export PATH="$MINICONDA_INSTALL_PATH/bin:$PATH"
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
            alias conda_original=$MINICONDA_INSTALL_PATH/bin/conda
        fi
    fi
fi
