#!/bin/zsh
#########################################
# Script to test install script on Arch #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-22                      #
#########################################
set -e

# Get git root folder and set 
DOTFILES_ROOT=$(git rev-parse --show-toplevel)
BASE_ARCH_USER="dennis"
BASE_ARCH_PASSWORD="test"
PLATFORM="linux/amd64"
REBUILD_STAGE0=${REBUILD_STAGE0:-false}

# Rebuild container if not exists
if [ "$(docker images -q bakhuis/dotfiles:stage0 2> /dev/null)" = "" ] || [ "$REBUILD_STAGE0" = true ]; then
    REBUILD_STAGE0=true
fi

# Test Stage 0
if [ "$REBUILD_STAGE0" = true ]; then
    docker build \
        --platform $PLATFORM \
        --progress plain \
        --build-arg BASE_ARCH_USER=$BASE_ARCH_USER \
        --build-arg BASE_ARCH_PASSWORD=$BASE_ARCH_PASSWORD \
        -t bakhuis/dotfiles:stage0 \
        . \
        -f $DOTFILES_ROOT/install_scripts/tests/Dockerfile.stage0 
fi

# Test Stage 1
docker run \
    --rm \
    -it \
    --platform $PLATFORM \
    --name dotfiles_tests \
    -v $DOTFILES_ROOT:/dotfiles \
    -e BASE_ARCH_USER=$BASE_ARCH_USER \
    -e BASE_ARCH_PASSWORD=$BASE_ARCH_PASSWORD \
    -e REMOVE_ZSHRC_HOSTNAME=true \
    bakhuis/dotfiles:stage0 \
    /bin/bash -c "/dotfiles/install_scripts/tests/tests_on_arch.sh"

