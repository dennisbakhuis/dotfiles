############
# Starship #
############
# Starship is a prompt manager for ZSH. This script will check
# if Starship is installed and if it is, it will enable it. If
# Starship is not installed, it will try install it. For this it
# depends on brew when on macOS and pacman when on Arch Linux.


# Settings
ZSH_INIT_STARSHIP=${ZSH_INIT_STARSHIP:-"true"}    # enable starship
PRIORITY=120                                      # priority of this script


# Check if starship is installed else install it
if [ "$ZSH_INIT_STARSHIP" = "true" ]; then
    if command -v starship &> /dev/null; then
        eval "$(starship init zsh)"
    else
        # Check if mac or linux
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then  # Arch Linux
            pacman -S starship
        elif [[ "$OSTYPE" == "darwin"* ]]; then  # MacOs
            if command -v brew &> /dev/null; then
                brew install starship
            else
                echo "Homebrew is not installed. Cannot install starship."
            fi
        fi
        eval "$(starship init zsh)"
    fi
fi
