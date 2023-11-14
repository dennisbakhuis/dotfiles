############
# Homebrew #
############
# Homebrew is a package manager for macOS. This script will check
# if Homebrew is installed and if it is, it will enable it. All
# installed software from Homebrew will be available only after
# this script is run (or Homebrew is enabled in some other way).
# As other scripts may depend on Homebrew, it is recommended to
# have this script run as one of the first.


# Settings
ZSH_INIT_HOMEBREW=${ZSH_INIT_HOMEBREW:-"true"}                          # enable homebrew
HOMEBREW_EXECUTABLE=${HOMEBREW_EXECUTABLE:-"/opt/homebrew/bin/brew"}    # homebrew executable
PRIORITY=10                                                             # priority of this script


# Enable Homebrew
if [ "$ZSH_INIT_HOMEBREW" = "true" ]; then
    if [ -f "$HOMEBREW_EXECUTABLE" ]; then
        eval "$($HOMEBREW_EXECUTABLE shellenv)"
    fi
fi
