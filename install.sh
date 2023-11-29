#!/bin/sh
#################################################
# Install script for my configs on new machines #
#                                               #
# This script is independent of OS (Mac/Arch)   #
# And installs my default environment           #
#                                               #
# Make sure that a hostname is set up as this   #
# is used for some configs                      #
#                                               #
# Author: Dennis Bakhuis                        #
# Date: 2023-11-28                              #
#################################################
INSTALLER_VERSION=0.2.0     # Version of this installer
set -e                      # Exit script immediately on first error.


#########################################
# General settings and helper functions #
#########################################
export BASE_USER=${BASE_USER:-dennis}       # User to be created in Arch with sudo rights
export DOTFILES_ROOT=$(pwd)                 # Location of the dotfiles
export STAGE2=${STAGE2:-false}              # Install stage 2 (GUI + Python dev)

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

if [ "$(id -u)" -eq 0 ]; then
    printf "Stage 0\n-------\n"
    source $MAIN_INSTALL_SCRIPTS/arch_base.sh
    printf "\n\n *** To continue, run this script as \`$BASE_USER\`\n"
    exit 0
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
echo $BASE_PASSWORD | sudo -S echo "Sudo password set"

##############
# Components #
##############
source $MAIN_INSTALL_SCRIPTS/homebrew.sh    # 1-MAC: Homebrew (package manager)
source $MAIN_INSTALL_SCRIPTS/git.sh         # 2-BOTH: Git (version control)
source $MAIN_INSTALL_SCRIPTS/zsh.sh         # 3-BOTH: Zsh (shell)
source $MAIN_INSTALL_SCRIPTS/fzf.sh         # 4-BOTH: Fzf (fuzzy finder and friends)
source $MAIN_INSTALL_SCRIPTS/neovim.sh      # 5-BOTH: Neovim (text editor)
source $MAIN_INSTALL_SCRIPTS/ssh.sh         # 6-BOTH: Ssh (secure shell)
source $MAIN_INSTALL_SCRIPTS/paru.sh        # 7-Arch: Paru (AUR helper)
source $MAIN_INSTALL_SCRIPTS/fetch.sh       # 8-BOTH: Neofetch/Zeitfetch (system info)


#######################################################################
# Stage 2 - GUI apps and Python dev environment                       #
#######################################################################
# This stage installs graphical applications if needed. For me this   #
# is only needed if on MacOs or when INSTALL_GUI_APPS is set to true. #
#######################################################################

# if INSTALL_GUI_APPS is not set, check if on mac or arch and set accordingly
if [ -z "$INSTALL_GUI_APPS" ]; then
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        printf " *** Detected: Arch Linux (no GUI apps required)\n"
        INSTALL_GUI_APPS=false
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        printf " *** Detected: MacOs (installing GUI apps)\n"
        INSTALL_GUI_APPS=true
    fi
else
    printf " *** INSTALL_GUI_APPS is set to $INSTALL_GUI_APPS\n"
fi

##############
# Components #
#############

if [ "$STAGE2" == "true"]; then

    source $MAIN_INSTALL_SCRIPTS/wezterm.sh     # 1-BOTH: Wezterm
    source $MAIN_INSTALL_SCRIPTS/micromamba.sh  # 2-BOTH: Micromamba (miniconda)

fi

