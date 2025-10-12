# ====================================================================
# Fetch Tool Integration (Neofetch/Zeitfetch)
# ====================================================================
# Displays system information on login shells only (not every new shell)
#
# Author: Dennis Bakhuis
# Date: 2025-10-11
# ====================================================================

# Only run on login shells to avoid displaying on every terminal/pane
if status is-login
    # macOS: Use zeitfetch if available
    if test (uname) = "Darwin"
        if command -v zeitfetch &>/dev/null
            zeitfetch
        end
    # Linux: Use neofetch if available
    else
        if command -v neofetch &>/dev/null
            neofetch
        end
    end
end