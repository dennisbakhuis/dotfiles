#!/bin/sh
######################################
# Script to install isomorphic_copy  #
#                                    #
# Author: Dennis Bakhuis             #
# Date: 2024-03-12                   #
######################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
	set -e
fi

############
# Settings #
############
ISOMORPHIC_COPY_INSTALL=${ISOMORPHIC_COPY_INSTALL:-true}
ISOMORPHIC_COPY_PATH="$HOME/.tools/isomorphic_copy"

########
# Main #
########

# Only install isomorphic_copy if not yet installed
if [ "$ISOMORPHIC_COPY_INSTALL" = true ]; then
	if [ ! -d "$ISOMORPHIC_COPY_PATH" ]; then
		printf " *** Installing isomorphic_copy...\n"

		mkdir -p $HOME/.tools
		git clone https://github.com/ms-jpq/isomorphic_copy.git $ISOMORPHIC_COPY_PATH

	else
		printf " *** isomorphic_copy is already installed..."
	fi
fi
