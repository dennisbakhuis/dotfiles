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

print_header "📋 Isomorphic Copy Installation"

# Only install isomorphic_copy if not yet installed
if [ "$ISOMORPHIC_COPY_INSTALL" = true ]; then
	if [ ! -d "$ISOMORPHIC_COPY_PATH" ]; then
		print_step "Installing isomorphic_copy (clipboard over SSH)..."

		mkdir -p $HOME/.tools
		git clone https://github.com/ms-jpq/isomorphic_copy.git $ISOMORPHIC_COPY_PATH

		# Make the binaries executable (they are in the bin/ subdirectory)
		chmod +x "$ISOMORPHIC_COPY_PATH/bin/c"
		chmod +x "$ISOMORPHIC_COPY_PATH/bin/p"

		print_success "isomorphic_copy installed"
	else
		print_info "isomorphic_copy is already installed"

		# Ensure binaries are executable even if already installed
		if [ -f "$ISOMORPHIC_COPY_PATH/bin/c" ]; then
			chmod +x "$ISOMORPHIC_COPY_PATH/bin/c" 2>/dev/null || true
		fi
		if [ -f "$ISOMORPHIC_COPY_PATH/bin/p" ]; then
			chmod +x "$ISOMORPHIC_COPY_PATH/bin/p" 2>/dev/null || true
		fi
	fi

	print_success "📋 Isomorphic copy setup complete!"
fi
