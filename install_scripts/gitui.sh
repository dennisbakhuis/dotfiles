#!/bin/bash
######################################
# Script to install gitui            #
#                                    #
# A blazing fast terminal UI for git #
# written in Rust                    #
#                                    #
# Author: Dennis Bakhuis             #
# Date: 2025-11-18                   #
######################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

########
# Main #
########

print_header "🔀 gitui Installation"

# Install gitui on Mac, Arch, or Ubuntu
if [ ! -x "$(command -v gitui)" ]; then
    print_step "Installing gitui (blazing fast terminal UI for git)..."
    eval $PKG_INSTALL_NONINTERACTIVE gitui
    print_success "gitui installed"
else
    print_info "gitui is already installed"
fi

print_success "🔀 gitui setup complete!"
