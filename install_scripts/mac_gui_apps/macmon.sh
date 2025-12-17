#!/bin/bash
######################################
# Script to install macmon           #
#                                    #
# macOS system monitoring tool       #
# (CLI tool for Mac only)            #
#                                    #
# Author: Dennis Bakhuis             #
# Date: 2025-10-13                   #
######################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

########
# Main #
########

print_header "🖥️  macmon Installation"

# Install macmon via Homebrew
if [ ! -x "$(command -v macmon)" ]; then
    print_step "Installing macmon (macOS system monitor)..."
    eval $PKG_INSTALL_NONINTERACTIVE macmon
    print_success "macmon installed"
else
    print_info "macmon is already installed"
fi

print_success "🖥️  macmon setup complete!"
