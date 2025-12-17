#!/bin/bash
#########################################
# Script to install Neovim              #
#                                       #
# Installs dependencies:                #
#  - nodejs                             #
#  - npm                                #
#  - cmake                              #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-13                      #
#########################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

########
# Main #
########

print_header "📝 Neovim Installation"

# install neovim if not yet installed
if [ ! -x "$(command -v nvim)" ]; then
    print_step "Installing Neovim on $OS_TYPE..."
    eval $PKG_INSTALL_NONINTERACTIVE neovim
    print_success "Neovim installed"
else
    print_info "Neovim is already installed"
fi

# install nodejs if not yet installed
if [ ! -x "$(command -v node)" ]; then
    print_step "Installing nodejs..."
    eval $PKG_INSTALL_NONINTERACTIVE nodejs
    print_success "nodejs installed"
else
    print_info "nodejs is already installed"
fi

# install npm if not yet installed
if [ ! -x "$(command -v npm)" ]; then
    print_step "Installing npm..."
    eval $PKG_INSTALL_NONINTERACTIVE npm
    print_success "npm installed"
else
    print_info "npm is already installed"
fi

# install cmake if not yet installed
if [ ! -x "$(command -v cmake)" ]; then
    print_step "Installing cmake..."
    eval $PKG_INSTALL_NONINTERACTIVE cmake
    print_success "cmake installed"
else
    print_info "cmake is already installed"
fi

print_step "Configuring Neovim..."

# Backup existing neovim config if it exists and is not a symlink
if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
    BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
    print_warning "Backing up existing nvim config to $BACKUP_DIR"
    mv "$HOME/.config/nvim" "$BACKUP_DIR"
fi

# Remove old symlink if it exists
if [ -L "$HOME/.config/nvim" ]; then
    rm "$HOME/.config/nvim"
fi

# Ensure .config directory exists
mkdir -p $HOME/.config

# Link neovim lua config
ln -sf $DOTFILES_ROOT/nvim $HOME/.config/nvim
print_success "Neovim configuration linked"

print_success "📝 Neovim setup complete!"
