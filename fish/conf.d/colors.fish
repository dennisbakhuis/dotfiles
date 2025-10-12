# Fish Shell Color Configuration
# Author: Dennis Bakhuis
# Date: 2025-10-12

# Syntax Highlighting Colors
# These colors apply to commands as you type them

# Valid commands (green)
set -g fish_color_command green --bold

# Valid command arguments
set -g fish_color_param cyan

# Invalid/not found commands (red)
set -g fish_color_error red --bold

# Comments
set -g fish_color_comment brblack --italics

# Quoted strings
set -g fish_color_quote yellow

# Redirection operators (>, <, |)
set -g fish_color_redirection magenta --bold

# Command separators (;, &, &&, ||)
set -g fish_color_end blue

# Operators (*, ?, !)
set -g fish_color_operator magenta

# Escape sequences (\n, \t, etc)
set -g fish_color_escape cyan --bold

# Autosuggestions (grayed out suggestions from history)
# This is the key one - making it clearly different from your input
set -g fish_color_autosuggestion brblack

# Search matches
set -g fish_color_search_match --background=brblack

# Selection background
set -g fish_color_selection --background=brblack

# Pager colors (for completion menu)
set -g fish_pager_color_completion normal
set -g fish_pager_color_description yellow
set -g fish_pager_color_prefix cyan --bold
set -g fish_pager_color_progress brwhite --background=cyan
set -g fish_pager_color_selected_background --background=brblack