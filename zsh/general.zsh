#########################################
# General ZSh settings                  #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-12                      #
#########################################

###########
# History #
###########

# Save all history events (previous commands) to a file. The maximum number of
# events stored in memory is set to practically infinite (1000000). Additionally
# duplicate events are removed from the history file and memory. This means that
# the history does not always reflect the exact order of commands entered.

HISTFILE=~/.cache/zsh/history   # History file location
HISTSIZE=1000000                # Number of events stored in memory
SAVEHIST=$HISTSIZE              # Number of events stored in history file

setopt SHARE_HISTORY            # Share history between all sessions.
setopt EXTENDED_HISTORY         # History file in ':start:elapsed;command' format.
setopt HIST_FIND_NO_DUPS        # Do not show duplicates in history search.
setopt HIST_IGNORE_ALL_DUPS     # Delete previous matching history event and add new one.
setopt HIST_IGNORE_DUPS         # Do not add event if equal to previous one.
setopt HIST_IGNORE_SPACE        # Do not add an event starting with a space.
setopt HIST_SAVE_NO_DUPS        # Do not write a duplicate event to the history file.
setopt HIST_EXPIRE_DUPS_FIRST   # Expire a duplicate event first when trimming history.


##########
# Colors #
##########

# Load Zsh function to create default color objects
# Fills unicode characters for colors etc. in variables
# E.g. echo $fg[red]Hello World$reset_color
autoload -U colors && colors

