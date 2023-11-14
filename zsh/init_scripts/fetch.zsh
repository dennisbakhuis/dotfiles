#########################
# Neofetch or Zeitfetch #
#########################
# Run neofetch or zeitfetch, if installed and enabled
# Neofetch/Zeitfetch are used to display system information
# in the terminal prompt. Therefore, it is recommended to
# have this script run last.


# Settings
ZSH_INIT_FETCH=${ZSH_INIT_FETCH:-"true"}    # enable fetch
PRIORITY=1000                               # priority of this script


# Run neofetch or zeitfetch, if installed and enabled
if [ "$ZSH_INIT_FETCH" = "true" ]; then
    if [ -x "$(command -v neofetch)" ]; then
        neofetch
    elif [ -x "$(command -v zeitfetch)" ]; then
        zeitfetch
    fi
fi
