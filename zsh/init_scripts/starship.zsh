############
# Starship #
############
# Starship is a prompt manager for ZSH. This script will check
# if Starship is installed and if it is, it will enable it. 


# Settings
ZSH_INIT_STARSHIP=${ZSH_INIT_STARSHIP:-"true"}    # enable starship
PRIORITY=120                                      # priority of this script


# Check if starship is installed else install it
if [ "$ZSH_INIT_STARSHIP" = "true" ]; then
    if command -v starship &> /dev/null; then
        eval "$(starship init zsh)"
    fi
fi
