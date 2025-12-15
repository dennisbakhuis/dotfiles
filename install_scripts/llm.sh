#!/bin/sh
######################################
# Script to install llm              #
#                                    #
# CLI tool for interacting with      #
# Large Language Models              #
#                                    #
# Author: Dennis Bakhuis             #
# Date: 2025-12-15                   #
######################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

########
# Main #
########

print_header "🤖 llm Installation"

# Install llm - hybrid approach (brew on macOS, uv on Linux)
if [ ! -x "$(command -v llm)" ]; then
    print_step "Installing llm (LLM command-line tool)..."

    if [ "$OS_TYPE" = "macos" ]; then
        NONINTERACTIVE=1 brew install llm
    else
        # Use uv tool install on Linux
        uv tool install llm
    fi

    print_success "llm installed"
else
    print_info "llm is already installed"
fi

# Set up configuration
print_step "Setting up llm configuration..."
mkdir -p ~/.config/llm

# Backup existing config if not a symlink
if [ -f "$HOME/.config/llm/config.toml" ] && [ ! -L "$HOME/.config/llm/config.toml" ]; then
    BACKUP_FILE="$HOME/.config/llm/config.toml.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$HOME/.config/llm/config.toml" "$BACKUP_FILE"
    print_info "Backed up existing config to $BACKUP_FILE"
fi

# Remove old symlink if exists
if [ -L "$HOME/.config/llm/config.toml" ]; then
    rm "$HOME/.config/llm/config.toml"
fi

# Create symlink to dotfiles config
ln -sf "$DOTFILES_ROOT/llm_cli/config.toml" "$HOME/.config/llm/config.toml"
print_success "llm configuration linked"

# Show post-install instructions
echo ""
print_info "To configure API keys for LLM providers, run:"
print_step "  fish $DOTFILES_ROOT/llm_cli/setup_llm_keys.fish"
echo ""

print_success "🤖 llm setup complete!"
