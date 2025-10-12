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
    # Configure fzf.fish plugin to use fd for better performance and gitignore support
    # These variables are used by the fzf.fish plugin
    set -gx fzf_fd_opts --hidden --exclude .git --strip-cwd-prefix

    # Fallback: Set default fzf commands for systems without fzf.fish plugin
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --exclude .git'
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND 'fd --type d --strip-cwd-prefix --hidden --exclude .git'

    # Set fzf preview window options (works with both plugin and fallback)
    set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'
end