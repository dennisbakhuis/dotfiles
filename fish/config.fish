# Fish Shell Configuration
# Author: Dennis Bakhuis
# Date: 2025-10-10

# Set DOTFILES_ROOT (update this for each machine)
set -gx DOTFILES_ROOT $HOME/dotfiles

# Disable greeting message
set fish_greeting

# Set up history
set -gx fish_history_file $HOME/.local/share/fish/fish_history

# Initialize Starship prompt
if command -v starship &>/dev/null
    starship init fish | source
end

# Load secrets if they exist
if test -f $HOME/.secrets.fish
    source $HOME/.secrets.fish
end