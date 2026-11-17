#!/bin/bash
######################################
# Script to Tmux                     #
#                                    #
# Author: Dennis Bakhuis             #
# Date: 2024-02-14                   #
######################################

# Exit on error; only set if not already set
if [ -z "$-echo" ]; then
    set -e
fi


########
# Main #
########

# Only install tmux if not yet installed
if [ ! -x "$(command -v tmux)" ]; then
    printf " *** Installing Tmux on $OS_TYPE...\n"
    eval $PKG_INSTALL_NONINTERACTIVE tmux
else
    printf " *** Tmux is already installed..."
fi

# Check if DOTFILES_ROOT is set
if [ -z "$DOTFILES_ROOT" ]; then
    printf " *** ERROR(Tmux): DOTFILES_ROOT is not set, exiting...\n"
    exit 1
fi

# Backup existing tmux config if it exists and is not a symlink
if [ -f "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
    BACKUP_FILE="$HOME/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)"
    printf " *** Backing up existing .tmux.conf to $BACKUP_FILE...\n"
    mv "$HOME/.tmux.conf" "$BACKUP_FILE"
fi

# Remove old symlink if it exists
rm -f $HOME/.tmux.conf

# Link tmux configuration
ln -sf $DOTFILES_ROOT/tmux/tmux.conf $HOME/.tmux.conf

# Install TPM (Tmux Plugin Manager) if not already installed
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    printf " *** Installing TPM (Tmux Plugin Manager)...\n"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    printf " *** TPM installed. Run 'prefix + I' in tmux to install plugins.\n"
else
    printf " *** TPM is already installed.\n"
fi

# Install all plugins declared in tmux.conf without needing `prefix + I`
printf " *** Installing tmux plugins via TPM...\n"
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || printf " *** WARNING: TPM plugin install failed, run 'prefix + I' in tmux.\n"

# tmux-agent-sidebar needs a prebuilt binary; fetch it non-interactively so the
# in-tmux setup wizard never pops up on a fresh machine
AGENT_SIDEBAR_DIR="$HOME/.tmux/plugins/tmux-agent-sidebar"
if [ -d "$AGENT_SIDEBAR_DIR" ] && [ ! -x "$AGENT_SIDEBAR_DIR/bin/tmux-agent-sidebar" ]; then
    printf " *** Downloading tmux-agent-sidebar binary...\n"
    bash "$AGENT_SIDEBAR_DIR/install-wizard.sh" download-binary </dev/null || printf " *** WARNING: tmux-agent-sidebar binary download failed.\n"
else
    printf " *** tmux-agent-sidebar binary already present (or plugin missing).\n"
fi
