#!/bin/zsh
#######
# fzf #
#######

# Check if fzf is installed
if command -v fzf &> /dev/null; then
    # Check if OS is Mac or Arch
    if [ "$(uname)" = "Darwin" ]; then
        source "/opt/homebrew/opt/fzf/shell/completion.zsh"
        source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
    elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
        # Arch
        source "/usr/share/fzf/completion.zsh"
        source "/usr/share/fzf/key-bindings.zsh"
    fi
fi
