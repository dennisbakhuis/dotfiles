# Zoxide - smarter cd command
# https://github.com/ajeetdsouza/zoxide
#
# Usage:
#   z foo              # cd into highest ranked directory matching foo
#   z foo bar          # cd into highest ranked directory matching foo and bar
#   z ~/foo            # z also works like a regular cd command
#   zi foo             # cd with interactive selection (using fzf)
#
# Other commands:
#   zoxide query foo   # query database for matches
#   zoxide add /path   # add path to database
#   zoxide remove /path # remove path from database

# Initialize zoxide if it's installed
if type -q zoxide
    zoxide init fish | source
end