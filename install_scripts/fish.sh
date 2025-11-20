#!/bin/sh
######################################
# Script to install fish shell      #
#                                    #
# Also install packages:             #
#  - starship                        #
#  - lsd (modern ls with colors)     #
#  - zoxide (smart directory jumper) #
#                                    #
# Author: Dennis Bakhuis             #
# Date: 2025-10-10                   #
######################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi

########
# Main #
########

print_header "🐠 Fish Shell Installation"

# check if fish is installed
if [ ! -x "$(command -v fish)" ]; then
    print_step "Installing fish shell on $OS_TYPE..."
    eval $PKG_INSTALL_NONINTERACTIVE fish
    print_success "Fish shell installed"
else
    print_info "Fish shell is already installed"
fi

# check if lsd is installed
if [ ! -x "$(command -v lsd)" ]; then
    print_step "Installing lsd (modern ls with colorful icons)..."
    eval $PKG_INSTALL_NONINTERACTIVE lsd
    print_success "lsd installed"
else
    print_info "lsd is already installed"
fi

# check if starship is installed
if [ ! -x "$(command -v starship)" ]; then
    print_step "Installing starship prompt..."
    # Install starship (check if on 32bit arm for special handling)
    if [ "$(uname -m)" = "armv7l" ]; then
        # 32bit arm (Raspberry Pi <4) - use curl installer
        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -y -f
    else
        # Regular install via package manager
        eval $PKG_INSTALL_NONINTERACTIVE starship
    fi
    print_success "Starship prompt installed"
else
    print_info "Starship is already installed"
fi

# check if zoxide is installed
if [ ! -x "$(command -v zoxide)" ]; then
    print_step "Installing zoxide (smart cd)..."
    eval $PKG_INSTALL_NONINTERACTIVE zoxide
    print_success "Zoxide installed"
else
    print_info "Zoxide is already installed"
fi

# check if DOTFILES_ROOT is set
if [ -z "$DOTFILES_ROOT" ]; then
    print_error "DOTFILES_ROOT is not set, exiting"
    exit 1
fi

print_step "Configuring Fish shell..."

# Backup existing fish config if it exists and is not a symlink
if [ -d "$HOME/.config/fish" ] && [ ! -L "$HOME/.config/fish" ]; then
    BACKUP_DIR="$HOME/.config/fish.backup.$(date +%Y%m%d_%H%M%S)"
    print_warning "Backing up existing fish config to $BACKUP_DIR"
    mv "$HOME/.config/fish" "$BACKUP_DIR"
fi

# Remove old symlink if it exists
if [ -L "$HOME/.config/fish" ]; then
    rm "$HOME/.config/fish"
fi

# Create fish config directory structure
mkdir -p $HOME/.config/fish

# Link fish configuration (using -f to force overwrite if exists)
ln -sf $DOTFILES_ROOT/fish/config.fish $HOME/.config/fish/config.fish
ln -sf $DOTFILES_ROOT/fish/fish_variables $HOME/.config/fish/fish_variables

# Link entire conf.d directory (for modular configuration)
ln -sfn $DOTFILES_ROOT/fish/conf.d $HOME/.config/fish/conf.d

# Handle completions directory - backup if exists and not a symlink
if [ -d "$HOME/.config/fish/completions" ] && [ ! -L "$HOME/.config/fish/completions" ]; then
    COMPLETIONS_BACKUP="$HOME/.config/fish/completions.backup.$(date +%Y%m%d_%H%M%S)"
    print_warning "Backing up existing completions to $COMPLETIONS_BACKUP"
    mv "$HOME/.config/fish/completions" "$COMPLETIONS_BACKUP"
fi

# Remove old symlink if it exists
if [ -L "$HOME/.config/fish/completions" ]; then
    rm "$HOME/.config/fish/completions"
fi

# Link entire completions directory (for tab completions)
ln -sfn $DOTFILES_ROOT/fish/completions $HOME/.config/fish/completions
print_success "Fish configuration files linked"

# Install Fisher plugin manager if not already installed
if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
    print_step "Installing Fisher plugin manager..."
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    print_success "Fisher installed"
else
    print_info "Fisher is already installed"
fi

# Install fzf.fish plugin via Fisher
print_step "Installing fzf.fish plugin..."
fish -c "fisher install PatrickF1/fzf.fish" 2>/dev/null && print_success "fzf.fish plugin installed" || print_info "fzf.fish plugin already installed"

# Set default shell to fish
print_step "Setting default shell to fish..."

# Get the fish binary path
FISH_PATH=$(which fish)

# Check if fish is in /etc/shells, if not add it
if ! grep -q "$FISH_PATH" /etc/shells; then
    print_warning "Adding fish to /etc/shells"
    echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
fi

# Change default shell (different commands for different OSes)
# Only change if not already the default shell
if command -v getent >/dev/null 2>&1; then
  CURRENT_SHELL=$(getent passwd "$BASE_USER" | cut -d: -f7)
elif [[ "$OSTYPE" == "darwin"* ]]; then
  CURRENT_SHELL=$(dscl . -read /Users/"$BASE_USER" UserShell | awk '{print $2}')
else
  CURRENT_SHELL=$(grep "^$BASE_USER:" /etc/passwd | cut -d: -f7)
fi

if [ "$CURRENT_SHELL" != "$FISH_PATH" ]; then
    print_step "Changing default shell to fish..."
    if [ "$OS_TYPE" = "macos" ]; then
        sudo chsh -s "$FISH_PATH" $BASE_USER
    else
        # Linux (Arch/Ubuntu) uses usermod
        sudo usermod --shell "$FISH_PATH" $BASE_USER
    fi
    print_success "Default shell changed to fish"
else
    print_info "Fish is already the default shell"
fi

print_success "🐠 Fish shell setup complete!"