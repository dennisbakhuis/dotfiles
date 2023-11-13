#!/bin/zsh
#########################
# Neofetch or Zeitfetch #
#########################

# check if Neofetch is installed and run it
if [ -x "$(command -v neofetch)" ]; then
  neofetch
elif [ -x "$(command -v zeitfetch)" ]; then
  zeitfetch
fi

