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

# Configure LS_COLORS for lsd (and other ls replacements)
set -gx LS_COLORS "di=38;5;33:ln=38;5;51:so=38;5;13:pi=38;5;5:ex=38;5;40:bd=38;5;68:cd=38;5;68:su=38;5;124:sg=38;5;124:tw=38;5;68:ow=38;5;68:*.rs=38;5;208:*.py=38;5;41:*.js=38;5;226:*.ts=38;5;38:*.json=38;5;178:*.yml=38;5;176:*.yaml=38;5;176:*.md=38;5;220:*.sh=38;5;113:*.toml=38;5;173:*.go=38;5;81:*.txt=38;5;253"

# Load secrets if they exist
if test -f $HOME/.secrets.fish
    source $HOME/.secrets.fish
end
# bun
set --export BUN_INSTALL "$HOME/Library/Application Support/reflex/bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Fix for Cmd-V paste functionality
if status is-interactive
    # Define the paste function if it doesn't exist
    function __fish_paste
        set -l data (pbpaste)
        if test -n "$data"
            commandline -i -- $data
        end
    end
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
