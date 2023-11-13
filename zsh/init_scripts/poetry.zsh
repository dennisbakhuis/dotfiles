#!/bin/zsh
#################
# Python Poetry #
#################

# Settings
POETRY_ENV_NAME=${POETRY_ENV_NAME:-"poetry"}

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

