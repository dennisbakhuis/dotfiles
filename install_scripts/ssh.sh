#!/bin/bash
#########################################
# Script to install SSH                 #
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

# install ssh if not yet installed
if [ ! -x "$(command -v ssh)" ]; then
    printf " *** Installing SSH on $OS_TYPE...\n"

    if [ "$OS_TYPE" = "macos" ]; then
        # macOS (usually pre-installed, but just in case)
        NONINTERACTIVE=1 brew install openssh
    elif [ "$OS_TYPE" = "arch" ]; then
        # Arch Linux
        eval $PKG_INSTALL_NONINTERACTIVE openssh
    elif [ "$OS_TYPE" = "ubuntu" ]; then
        # Ubuntu/Debian
        eval $PKG_INSTALL_NONINTERACTIVE openssh-client openssh-server
    else
        printf " *** ERROR: Unsupported OS type: $OS_TYPE\n"
        exit 1
    fi
else
    printf " *** SSH is already installed...\n"
fi

# Check if DOTFILES_ROOT is set
if [ -z "$DOTFILES_ROOT" ]; then
    printf " *** ERROR(SSH): DOTFILES_ROOT is not set, exiting...\n"
    exit 1
fi

# Ensure .ssh directory exists
mkdir -p $HOME/.ssh

# Backup existing ssh config if it exists and is not a symlink
if [ -f "$HOME/.ssh/config" ] && [ ! -L "$HOME/.ssh/config" ]; then
    BACKUP_FILE="$HOME/.ssh/config.backup.$(date +%Y%m%d_%H%M%S)"
    printf " *** Backing up existing ssh config to $BACKUP_FILE...\n"
    mv "$HOME/.ssh/config" "$BACKUP_FILE"
fi

# Remove old symlink if it exists
rm -f $HOME/.ssh/config

# Link ssh configuration
ln -sf $DOTFILES_ROOT/ssh/config $HOME/.ssh/config

# Resolve machine-specific host file: prefer ssh/hosts/<hostname>.conf,
# fall back to ssh/hosts/<os>.conf. Both tracked in the repo so changes
# propagate via git, while only the relevant file is active per machine.
MACHINE_HOSTNAME=$(hostname -s | tr '[:upper:]' '[:lower:]')
HOST_CONF="$DOTFILES_ROOT/ssh/hosts/$MACHINE_HOSTNAME.conf"
OS_CONF="$DOTFILES_ROOT/ssh/hosts/$OS_TYPE.conf"

if [ -f "$HOST_CONF" ]; then
    printf " *** Linking ~/.ssh/config.local -> ssh/hosts/%s.conf\n" "$MACHINE_HOSTNAME"
    ACTIVE_CONF="$HOST_CONF"
elif [ -f "$OS_CONF" ]; then
    printf " *** No hostname-specific config for %s, falling back to %s.conf\n" "$MACHINE_HOSTNAME" "$OS_TYPE"
    ACTIVE_CONF="$OS_CONF"
else
    printf " *** No hostname or OS config found. Create ssh/hosts/%s.conf or ssh/hosts/%s.conf\n" "$MACHINE_HOSTNAME" "$OS_TYPE"
    ACTIVE_CONF=""
fi

# Replace existing config.local (file or symlink) with a symlink to the
# resolved tracked file, or an empty placeholder if none exists yet.
if [ -L "$HOME/.ssh/config.local" ] || [ -f "$HOME/.ssh/config.local" ]; then
    rm -f "$HOME/.ssh/config.local"
fi

if [ -n "$ACTIVE_CONF" ]; then
    ln -sf "$ACTIVE_CONF" "$HOME/.ssh/config.local"
else
    cat > "$HOME/.ssh/config.local" <<EOF
# Machine-specific SSH host entries.
# Create ssh/hosts/$MACHINE_HOSTNAME.conf in the dotfiles repo to track
# entries for this machine, or ssh/hosts/$OS_TYPE.conf for an OS-level
# fallback, then re-run install.sh to link it here.
EOF
    chmod 600 "$HOME/.ssh/config.local"
fi
