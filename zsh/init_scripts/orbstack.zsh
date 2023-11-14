############
# Orbstack #
############
# Orbstack is Docker desktop replacement for development
# which works great on Mac.

# Settings
ZSH_INIT_ORBSTACK=${ZSH_INIT_ORBSTACK:-"true"}                                  # enable orbstack
ORBSTACK_SHELL_INIT=${ORBSTACK_SHELL_INIT:-"$HOME/.orbstack/shell/init.zsh"}    # Orbstack init file
PRIORITY=200                                                                    # priority of this script


# Check if starship is installed else install it
if [ "$ZSH_INIT_ORBSTACK" = "true" ]; then
    if [ -f "$ORBSTACK_SHELL_INIT" ]; then
        source "$ORBSTACK_SHELL_INIT" 2> /dev/null || :
    fi
fi
