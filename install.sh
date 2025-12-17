#!/bin/bash
#################################################
# Install script for my configs on new machines #
#                                               #
# This script works on macOS, Arch, and Ubuntu  #
# And installs my default environment           #
#                                               #
# Prerequisites:                                #
# - Git must be installed                       #
# - macOS: Homebrew must be installed           #
# - Arch/Ubuntu: Standard package manager       #
#                                               #
# Author: Dennis Bakhuis                        #
# Date: 2024-10-10                              #
#################################################
INSTALLER_VERSION=0.3.0     # Version of this installer
set -e                      # Exit script immediately on first error.


#########################################
# General settings and helper functions #
#########################################
export BASE_USER=${BASE_USER:-dennis}       # User to be created in Arch with sudo rights
export DOTFILES_ROOT=$(pwd)                 # Location of the dotfiles
export STAGE2=${STAGE2:-false}              # Install stage 2 (GUI + Python dev)

# Color codes for pretty output
export COLOR_RESET='\033[0m'
export COLOR_BOLD='\033[1m'
export COLOR_RED='\033[0;31m'
export COLOR_GREEN='\033[0;32m'
export COLOR_YELLOW='\033[0;33m'
export COLOR_BLUE='\033[0;34m'
export COLOR_MAGENTA='\033[0;35m'
export COLOR_CYAN='\033[0;36m'

# Helper functions for colored output
print_header() {
    printf "${COLOR_BOLD}${COLOR_CYAN}$1${COLOR_RESET}\n"
}

print_success() {
    printf "${COLOR_GREEN}✓ $1${COLOR_RESET}\n"
}

print_info() {
    printf "${COLOR_BLUE}ℹ $1${COLOR_RESET}\n"
}

print_warning() {
    printf "${COLOR_YELLOW}⚠ $1${COLOR_RESET}\n"
}

print_error() {
    printf "${COLOR_RED}✗ $1${COLOR_RESET}\n"
}

print_step() {
    printf "${COLOR_MAGENTA}▶ $1${COLOR_RESET}\n"
}

# Detect OS and set package manager
if [ "$(uname)" = "Darwin" ]; then
    export OS_TYPE="macos"
    export PKG_MANAGER="brew"
    export PKG_INSTALL="brew install"
    export PKG_INSTALL_NONINTERACTIVE="NONINTERACTIVE=1 brew install"
elif [ -f /etc/arch-release ]; then
    export OS_TYPE="arch"
    export PKG_MANAGER="pacman"
    export PKG_INSTALL="sudo pacman -S --noconfirm"
    export PKG_INSTALL_NONINTERACTIVE="sudo pacman -S --noconfirm"
elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
    export OS_TYPE="ubuntu"
    export PKG_MANAGER="apt"
    export PKG_INSTALL="sudo apt-get install -y"
    export PKG_INSTALL_NONINTERACTIVE="sudo DEBIAN_FRONTEND=noninteractive apt-get install -y"
else
    printf " *** ERROR: Unsupported operating system\n"
    exit 1
fi

printf "Detected OS: $OS_TYPE (using $PKG_MANAGER)\n"

# if BASE_PASSWORD is not set, ask for it
if [ -z "$BASE_PASSWORD" ]; then
    printf " *** Enter password for user \`$BASE_USER\`: "
    read -s BASE_PASSWORD
    printf "\n"
fi


##################################################################
# Stage 0 - Prepare base Arch system (only executed as root)     #
##################################################################
# When running this script as root on Arch it will first install #
# the arch_base script.                                          #
##################################################################
printf "Bakhuis system installer (v$INSTALLER_VERSION)\n===================================\n"

# Location of the install scripts
MAIN_INSTALL_SCRIPTS=$DOTFILES_ROOT/install_scripts

# Check prerequisites
if [ ! -x "$(command -v git)" ]; then
    printf " *** ERROR: Git is not installed. Please install git first.\n"
    exit 1
fi

if [ "$OS_TYPE" = "macos" ] && [ ! -x "$(command -v brew)" ]; then
    printf " *** ERROR: Homebrew is not installed on macOS.\n"
    printf " *** Please install Homebrew from https://brew.sh\n"
    exit 1
fi

# Stage 0 only runs on Arch when executed as root
if [ "$(id -u)" -eq 0 ]; then
    if [ "$OS_TYPE" = "arch" ]; then
        printf "Stage 0\n-------\n"
        source $MAIN_INSTALL_SCRIPTS/arch_base.sh
        printf "\n\n *** To continue, run this script as \`$BASE_USER\`\n"
        exit 0
    else
        printf " *** ERROR: Do not run this script as root on $OS_TYPE\n"
        exit 1
    fi
elif [ "$(whoami)" != "$BASE_USER" ]; then
    # Script is run as non-root user that is not $BASE_USER
    printf " *** ERROR: This script should be run as \`$BASE_USER\`\n"
    exit 1
fi

# Hostname variable can now be set
export HOSTNAME=$(hostname)


###################################################################
# Stage 1 - default shell system                                  #
###################################################################
# The main stage runs as $BASE_USER and installs components.      #
# Components do their own checks if they are already installed.   #
# The order of the components is important!                       #
###################################################################

# pre-type sudo password
echo "$BASE_PASSWORD" | sudo -S echo "Sudo password set"

# Update package manager on Linux systems
if [ "$OS_TYPE" = "ubuntu" ]; then
    printf " *** Updating apt package lists...\n"
    sudo apt-get update -y
    printf " *** Upgrading installed packages...\n"
    sudo apt-get upgrade -y
elif [ "$OS_TYPE" = "arch" ]; then
    printf " *** Updating pacman databases and packages...\n"
    sudo pacman -Syu --noconfirm
fi

##############
# Components #
##############
source $MAIN_INSTALL_SCRIPTS/homebrew.sh        # 1-MAC: Homebrew (package manager)
source $MAIN_INSTALL_SCRIPTS/git.sh             # 2-BOTH: Git (version control)
source $MAIN_INSTALL_SCRIPTS/fish.sh            # 3-BOTH: Fish (shell)
source $MAIN_INSTALL_SCRIPTS/fzf.sh             # 4-BOTH: Fzf (fuzzy finder and friends)
source $MAIN_INSTALL_SCRIPTS/neovim.sh          # 5-BOTH: Neovim (text editor)
source $MAIN_INSTALL_SCRIPTS/ssh.sh             # 6-BOTH: Ssh (secure shell)
source $MAIN_INSTALL_SCRIPTS/fetch.sh           # 7-BOTH: Neofetch/Zeitfetch (system info)
source $MAIN_INSTALL_SCRIPTS/tmux.sh            # 8-BOTH: Tmux (terminal multiplexer)
source $MAIN_INSTALL_SCRIPTS/python_uv.sh       # 9-BOTH: uv (Python package manager)
source $MAIN_INSTALL_SCRIPTS/llm.sh             # 10-BOTH: llm (LLM command-line tool)
source $MAIN_INSTALL_SCRIPTS/isomorphic_copy.sh # 11-BOTH: isomorphic_copy (clipboard over SSH)
source $MAIN_INSTALL_SCRIPTS/htop.sh            # 12-BOTH: htop (interactive process viewer)
source $MAIN_INSTALL_SCRIPTS/gitui.sh           # 13-BOTH: gitui (terminal UI for git)
source $MAIN_INSTALL_SCRIPTS/claude.sh          # 14-BOTH: Claude Code (AI coding assistant)

# Apply macOS defaults if on macOS
if [ "$OS_TYPE" = "macos" ]; then
    source $MAIN_INSTALL_SCRIPTS/default_mac_settings.sh  # 10-MAC: macOS system defaults
fi


#######################################################################
# Stage 2 - macOS GUI applications                                      #
#######################################################################
# This stage installs GUI applications on macOS.                       #
# Automatically runs on macOS, skipped on Linux.                       #
#######################################################################

if [ "$OS_TYPE" = "macos" ]; then
    printf "\nStage 2 - GUI Applications\n--------------------------\n"
    source $MAIN_INSTALL_SCRIPTS/mac_gui_apps/alacritty.sh     # Terminal emulator
    source $MAIN_INSTALL_SCRIPTS/mac_gui_apps/orbstack.sh      # Docker/Linux containers
    source $MAIN_INSTALL_SCRIPTS/mac_gui_apps/flashspace.sh    # Workspace manager (install + config)
    source $MAIN_INSTALL_SCRIPTS/mac_gui_apps/vscode.sh        # Visual Studio Code editor
    source $MAIN_INSTALL_SCRIPTS/mac_gui_apps/signal.sh        # Signal messaging app
    source $MAIN_INSTALL_SCRIPTS/mac_gui_apps/macmon.sh        # macOS system monitor
fi
