# ====================================================================
# Fetch Tool Integration (Neofetch/Fastfetch)
# ====================================================================
# Displays system information on login shells only (not every new shell)
#
# Author: Dennis Bakhuis
# Date: 2025-10-11
# ====================================================================

# Only run on login shells to avoid displaying on every terminal/pane
if status is-login
    # macOS: Use fastfetch if available
    if test (uname) = "Darwin"
        if command -v fastfetch &>/dev/null
            fastfetch
        end
    # Linux: Use neofetch if available
    else
        if command -v neofetch &>/dev/null
            neofetch
        end
    end
end