#################
# Python Poetry #
#################
# Poetry is a package manager for Python. This script will check
# if Poetry is installed and if it is, it will create an alias.
# This package assumes that Poetry is installed in a conda(mamba)
# environment.


# Settings
ZSH_INIT_POETRY=${ZSH_INIT_POETRY:-"true"}    # enable poetry
POETRY_ENV_NAME=${POETRY_ENV_NAME:-"poetry"}  # poetry environment name
PRIORITY=110                                  # priority of this script


# Init Poetry
if [ "$ZSH_INIT_POETRY" = "true" ]; then
    # Check in MAMBA prefix or CONDA prefix exists
    if [ -v MAMBA_ROOT_PREFIX ]; then
        # Mamba prefix is set
        PYTHON_ROOT_PREFIX="$MAMBA_ROOT_PREFIX"
        
    elif [ -v CONDA_ROOT_PREFIX ]; then
        # Conda prefix is set
        PYTHON_ROOT_PREFIX="$CONDA_ROOT_PREFIX"
    fi
    
    # Check if poetry is installed in env
    POETRY_EXECUTABLE="$PYTHON_ROOT_PREFIX/envs/$POETRY_ENV_NAME/bin/poetry"
    
    if [ -f "$POETRY_EXECUTABLE" ]; then
        alias poetry="$POETRY_EXECUTABLE"
    fi
fi
