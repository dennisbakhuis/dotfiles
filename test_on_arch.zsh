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
BASE_USER="dennis"
BASE_PASSWORD="test"
HOSTNAME="test_system"
PLATFORM="linux/amd64"
REBUILD_STAGE0=${REBUILD_STAGE0:-false}
REBUILD_STAGE1=${REBUILD_STAGE1:-false}


###########
# Stage 0 #
###########

# Rebuild Stage-0 container if not exists
if [ "$(docker images -q bakhuis/dotfiles:stage0 2> /dev/null)" = "" ] || [ "$REBUILD_STAGE0" = true ]; then
    REBUILD_STAGE0=true
fi

# Test Stage 0
if [ "$REBUILD_STAGE0" = true ]; then
    docker build \
        --platform $PLATFORM \
        --progress plain \
        --build-arg BASE_USER=$BASE_USER \
        --build-arg BASE_PASSWORD=$BASE_PASSWORD \
        --build-arg HOSTNAME=$HOSTNAME \
        -t bakhuis/dotfiles:stage0 \
        . \
        -f $DOTFILES_ROOT/install_scripts/tests/Dockerfile.stage0 
fi


###########
# Stage 1 #
###########

# Rebuid Stage-1 container if not exists
if [ "$(docker images -q bakhuis/dotfiles:stage1 2> /dev/null)" = "" ] || [ "$REBUILD_STAGE1" = true ]; then
    REBUILD_STAGE1=true
fi

# Test Stage 1
if [ "$REBUILD_STAGE1" = true ]; then
    docker build \
        --platform $PLATFORM \
        --progress plain \
        --build-arg BASE_USER=$BASE_USER \
        --build-arg BASE_PASSWORD=$BASE_PASSWORD \
        --build-arg HOSTNAME=$HOSTNAME \
        -t bakhuis/dotfiles:stage1 \
        . \
        -f $DOTFILES_ROOT/install_scripts/tests/Dockerfile.stage1 
fi

# # Test Stage 1
# docker run \
#     --rm \
#     -it \
#     --platform $PLATFORM \
#     --name dotfiles_tests \
#     -v $DOTFILES_ROOT:/dotfiles \
#     -e BASE_USER=$BASE_USER \
#     -e BASE_PASSWORD=$BASE_PASSWORD \
#     -e REMOVE_ZSHRC_HOSTNAME=true \
#     -e HOSTNAME=$HOSTNAME \
#     bakhuis/dotfiles:stage0 \
#     /bin/bash -c "/dotfiles/install_scripts/tests/tests_on_arch.sh"
#
