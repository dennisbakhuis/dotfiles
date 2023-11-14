################
# ZSh Antidote #
################
# ZSh Antidote is a plugin manager for ZSh. It is used to
# install and manage plugins for ZSh. This script will
# check if ZSh Antidote is installed and if it is, it will
# enable it. 
# All installed plugins from ZSh Antidote will be available only after this
# script is run (or ZSh Antidote is enabled in some other way). As other
# scripts may depend on ZSh Antidote, it is recommended to have this script
# run as one of the first.
# Plugins are stored in $ZSH_CONFIG_ROOT/zsh_plugins.txt


# Settings
ZSH_INIT_ANTIDOTE=${ZSH_INIT_ANTIDOTE:-true}    # enable antidote
ANTIDOTE_ROOT=${ANTIDOTE_ROOT:-/antidote}       # antidote root directory
PRIORITY=20                                     # priority of this script


# Initialize Antidote if enabled
if [ "$ZSH_INIT_ANTIDOTE" = true ]; then

    # Check if Antidote is already installed otherwise install it
    if [ ! -d "$ZSH_CONFIG_ROOT/$ANTIDOTE_ROOT" ]; then
        git clone --depth=1 https://github.com/mattmc3/antidote.git $ZSH_CONFIG_ROOT/$ANTIDOTE_ROOT
    fi

    # Source Antidote
    source "$ZSH_CONFIG_ROOT/$ANTIDOTE_ROOT/antidote.zsh"

    # initialize plugins statically with $ZSH_CONFIG_ROOT/zsh_plugins.txt
    antidote load "$ZSH_CONFIG_ROOT/zsh_plugins.txt"
fi
