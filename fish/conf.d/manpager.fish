# Colorized manpages
# Author: Dennis Bakhuis
# Date: 2026-05-18
#
# Two layers:
#   1. LESS_TERMCAP_* — fallback colors when `less` is the man pager.
#      Maps bold/underline/standout escapes to ANSI colors.
#   2. MANPAGER=bat   — preferred when `bat` is installed; gives syntax-
#      aware highlighting that follows the current bat theme.
#
# If MANPAGER is set, the LESS_TERMCAP_* vars are unused but harmless.
# Unset MANPAGER (or uninstall bat) and the fallback takes over.

set -gx LESS_TERMCAP_md (printf "\e[1;36m")    # bold      → cyan
set -gx LESS_TERMCAP_me (printf "\e[0m")
set -gx LESS_TERMCAP_us (printf "\e[1;33m")    # underline → yellow
set -gx LESS_TERMCAP_ue (printf "\e[0m")
set -gx LESS_TERMCAP_so (printf "\e[1;44;33m") # standout  → yellow on blue (search hits, status line)
set -gx LESS_TERMCAP_se (printf "\e[0m")
set -gx LESS_TERMCAP_mb (printf "\e[1;31m")    # blink     → red

if command -v bat &>/dev/null
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx MANROFFOPT -c
end
