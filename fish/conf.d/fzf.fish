# ====================================================================
# FZF Configuration for Fish
# ====================================================================
# Uses the fzf.fish plugin (PatrickF1/fzf.fish) for better Fish integration
# The plugin provides:
#   - Ctrl+R: Search command history
#   - Ctrl+Alt+F: Search files
#   - Ctrl+Alt+L: Search git log
#   - Ctrl+Alt+S: Search git status
#   - Ctrl+Alt+P: Search processes
#   - Ctrl+Alt+V: Search environment variables
#
# Author: Dennis Bakhuis
# Date: 2025-10-11
# ====================================================================

if command -v fzf &>/dev/null
    # Set up fzf's built-in Fish shell integration
    # This provides Ctrl+T (files), Ctrl+R (history), and Alt+C (directories)
    fzf --fish | source

    # Configure fzf to use fd for better performance and gitignore support
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --exclude .git'
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND 'fd --type d --strip-cwd-prefix --hidden --exclude .git'

    # Set fzf options with tmux integration and preview windows
    # The --tmux flag makes fzf open in a tmux popup instead of inline
    set -gx FZF_DEFAULT_OPTS '--tmux bottom,40% --layout=reverse --border'

    # Preview for files (Ctrl+T)
    set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

    # Preview for directories (Alt+C)
    set -gx FZF_ALT_C_OPTS "--preview 'lsd --color=always --icon=always --tree --depth=2 {}'"
end