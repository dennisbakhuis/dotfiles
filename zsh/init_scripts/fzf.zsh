#######
# fzf #
#######
# fzf is a command-line fuzzy finder. This script will check
# if fzf is installed and if it is, it will enable it.


# Settings
ZSH_INIT_FZF=${ZSH_INIT_FZF:-"true"}    # enable fzf
PRIORITY=130                            # priority of this script


# Check if fzf is installed
if [ "$ZSH_INIT_FZF" = "true" ]; then
    if command -v fzf &> /dev/null; then
        # Check if OS is Mac or Arch
        if [ "$(uname)" = "Darwin" ]; then  # MacOs
            source "/opt/homebrew/opt/fzf/shell/completion.zsh"
            source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
        elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then  # Arch Linux
            source "/usr/share/fzf/completion.zsh"
            source "/usr/share/fzf/key-bindings.zsh"
        fi
    fi
fi
