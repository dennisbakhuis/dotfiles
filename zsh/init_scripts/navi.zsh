####################
# Navi cheat sheet #
####################
# Navi is a cheat sheet tool for the command-line.


# Settings
ZSH_INIT_NAVI=${ZSH_INIT_NAVI:-"true"}                      # enable Navi
NAVI_CONFIG_PATH=${NAVI_CONFIG_PATH:-"$HOME/dotfiles/navi"} # Navi config file
NAVI_CONFIG_NAME=${NAVI_CONFIG_NAME:-"navi_config.yaml"}    # Navi config file name
PRIORITY=200                                                # priority of this script


# Init Navi shell
if [ "$ZSH_INIT_NAVI" = "true" ]; then
    if command -v navi &> /dev/null; then
        eval "$(navi widget zsh)"

        export NAVI_CONFIG=${NAVI_CONFIG:-"$NAVI_CONFIG_PATH/$NAVI_CONFIG_NAME"}
    fi
fi
