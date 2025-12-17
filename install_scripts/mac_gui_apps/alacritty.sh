#!/bin/bash
#########################################
# Script to install Alacritty           #
#                                       #
# Including Nerd fonts:                 #
#  - FiraCode Nerd Font (with ligatures)#
#  - Adobe Source Code Pro font         #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-02-14                      #
#########################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

########
# Main #
########

print_header "🖥️  Alacritty Terminal Installation"

# Only run on macOS
if [ "$OS_TYPE" != "macos" ]; then
    print_info "Skipping Alacritty (macOS only)"
    exit 0
fi

# Install Alacritty if not yet installed
if [ ! -x "$(command -v alacritty)" ]; then
    print_step "Installing Alacritty terminal emulator..."

    # Install fonts and Alacritty
    NONINTERACTIVE=1 brew tap homebrew/cask-fonts
    NONINTERACTIVE=1 brew install --cask font-fira-code-nerd-font font-source-code-pro alacritty

    print_success "Alacritty installed successfully"
else
    print_info "Alacritty is already installed"

    # Still ensure fonts are installed
    print_step "Checking fonts..."
    NONINTERACTIVE=1 brew install --cask font-fira-code-nerd-font font-source-code-pro 2>/dev/null && print_success "Fonts installed" || print_info "Fonts already installed"
fi

# Check if DOTFILES_ROOT is set
if [ -z "$DOTFILES_ROOT" ]; then
    print_error "DOTFILES_ROOT is not set, exiting"
    exit 1
fi

print_step "Configuring Alacritty..."

# Backup existing alacritty config if it exists and is not a symlink
if [ -d "$HOME/.config/alacritty" ] && [ ! -L "$HOME/.config/alacritty" ]; then
    BACKUP_DIR="$HOME/.config/alacritty.backup.$(date +%Y%m%d_%H%M%S)"
    print_warning "Backing up existing alacritty config to $BACKUP_DIR"
    mv "$HOME/.config/alacritty" "$BACKUP_DIR"
fi

# Remove old symlink/directory if it exists
if [ -L "$HOME/.config/alacritty" ]; then
    rm "$HOME/.config/alacritty"
fi

# Ensure .config directory exists
mkdir -p $HOME/.config/alacritty

# Symlink the config file
ln -sf $DOTFILES_ROOT/alacritty/alacritty.macos.toml $HOME/.config/alacritty/alacritty.toml
print_success "Alacritty configuration linked"

# Important notice about permissions
print_warning "⚠️  IMPORTANT: Alacritty Permissions Required"
printf "${COLOR_YELLOW}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "When you first launch Alacritty, macOS will ask:"
echo "  \"Alacritty.app\" would like to access data from other apps."
echo ""
echo "You MUST click 'OK' to grant this permission for:"
echo "  • Clipboard access (copy/paste)"
echo "  • Full functionality of terminal features"
echo ""
echo "To manually manage permissions later:"
echo "  System Settings → Privacy & Security → Automation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf "${COLOR_RESET}\n"

print_success "🖥️  Alacritty setup complete!"
