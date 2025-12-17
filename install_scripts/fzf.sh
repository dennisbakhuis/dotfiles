#!/bin/bash
######################################
# Script to install fzf              #
#                                    #
# Including fd, ripgrep, bat         #
#                                    #
# Author: Dennis Bakhuis             #
# Date: 2023-11-12                   #
######################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

########
# Main #
########

print_header "🔍 FZF and Friends Installation"

# Install fzf on Mac, Arch, or Ubuntu
if [ ! -x "$(command -v fzf)" ]; then
    print_step "Installing fzf (fuzzy finder)..."
    eval $PKG_INSTALL_NONINTERACTIVE fzf
    print_success "fzf installed"
else
    print_info "fzf is already installed"
fi

# Install ripgrep
if [ ! -x "$(command -v rg)" ]; then
    print_step "Installing ripgrep (fast grep)..."
    eval $PKG_INSTALL_NONINTERACTIVE ripgrep
    print_success "ripgrep installed"
else
    print_info "ripgrep is already installed"
fi

# Install bat
if [ ! -x "$(command -v bat)" ]; then
    print_step "Installing bat (cat with wings)..."
    eval $PKG_INSTALL_NONINTERACTIVE bat
    print_success "bat installed"
else
    print_info "bat is already installed"
fi

# Install fd
if [ ! -x "$(command -v fd)" ]; then
    print_step "Installing fd (fast find)..."
    eval $PKG_INSTALL_NONINTERACTIVE fd
    print_success "fd installed"
else
    print_info "fd is already installed"
fi

print_success "🔍 FZF and friends setup complete!"
