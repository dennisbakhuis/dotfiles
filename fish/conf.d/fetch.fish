# ====================================================================
# Fetch Tool Integration (Fastfetch)
# ====================================================================
# Displays system information on login shells only (not every new shell)
#
# Author: Dennis Bakhuis
# Date: 2025-10-11
# ====================================================================

if status is-login
    if command -v fastfetch &>/dev/null
        fastfetch
    end
end