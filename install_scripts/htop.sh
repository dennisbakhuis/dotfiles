#!/bin/sh
######################################
# Script to install htop             #
#                                    #
# A cross-platform interactive       #
# process viewer                     #
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

print_header "📊 htop Installation"

# Install htop on Mac, Arch, or Ubuntu
if [ ! -x "$(command -v htop)" ]; then
    print_step "Installing htop (interactive process viewer)..."
    eval $PKG_INSTALL_NONINTERACTIVE htop
    print_success "htop installed"
else
    print_info "htop is already installed"
fi

print_success "📊 htop setup complete!"