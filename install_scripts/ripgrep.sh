#!/bin/bash
######################################
# Script to install and configure   #
# ripgrep (rg)                       #
#                                    #
# Ripgrep is a fast grep alternative#
# that respects .gitignore           #
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

print_header "🔍 Ripgrep Installation and Configuration"

# Check if DOTFILES_ROOT is set
if [ -z "$DOTFILES_ROOT" ]; then
    printf " *** ERROR(Ripgrep): DOTFILES_ROOT is not set, exiting...\n"
    exit 1
fi

# Install ripgrep if not already installed
if [ ! -x "$(command -v rg)" ]; then
    print_step "Installing ripgrep..."
    eval $PKG_INSTALL_NONINTERACTIVE ripgrep
    print_success "ripgrep installed"
else
    print_info "ripgrep is already installed ($(rg --version | head -n1))"
fi

# Set up ripgrep configuration
print_step "Setting up ripgrep configuration..."

# Create backup of existing config if it exists and is not a symlink
if [ -f "$HOME/.ripgreprc" ] && [ ! -L "$HOME/.ripgreprc" ]; then
    BACKUP_FILE="$HOME/.ripgreprc.backup.$(date +%Y%m%d_%H%M%S)"
    printf " *** Backing up existing .ripgreprc to $BACKUP_FILE...\n"
    mv "$HOME/.ripgreprc" "$BACKUP_FILE"
fi

# Remove old symlink if it exists
rm -f "$HOME/.ripgreprc"

# Create symlink to ripgrep config
ln -sf "$DOTFILES_ROOT/ripgrep/ripgreprc" "$HOME/.ripgreprc"
print_success "Linked ripgrep configuration"

# Verify the symlink
if [ -L "$HOME/.ripgreprc" ]; then
    print_info "Configuration file: ~/.ripgreprc -> $(readlink $HOME/.ripgreprc)"
else
    printf " *** WARNING: Failed to create symlink for .ripgreprc\n"
fi

# Add RIPGREP_CONFIG_PATH to shell config if not already present
# This is typically handled by the shell configuration itself
print_info "Make sure RIPGREP_CONFIG_PATH is set in your shell config:"
print_info "  export RIPGREP_CONFIG_PATH=\"\$HOME/.ripgreprc\""

print_success "🔍 Ripgrep setup complete!"
print_info ""
print_info "Ripgrep features enabled:"
print_info "  - Smart case-insensitive search"
print_info "  - Hidden files included in searches"
print_info "  - Line and column numbers shown"
print_info "  - Common directories excluded (node_modules, .git, etc.)"
print_info "  - Colorized output"
print_info ""
print_info "Usage examples:"
print_info "  rg 'pattern'              - Search for pattern in current directory"
print_info "  rg 'pattern' path/        - Search in specific directory"
print_info "  rg -t py 'pattern'        - Search only in Python files"
print_info "  rg -i 'pattern'           - Force case-insensitive search"
print_info "  rg -C 3 'pattern'         - Show 3 lines of context"
print_info "  rg --no-ignore 'pattern'  - Include ignored files"
