#!/bin/sh

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/workspaces.sh"

for i in "${!WORKSPACE_ICONS[@]}"; do
    sid=$(($i + 1))

    if [[ $sid -eq $ACTIVE_WORKSPACE ]]; then
      sketchybar --set space.$sid "${SELECTED_WORKSPACE_SETTINGS[@]}"
    else
      sketchybar --set space.$sid background.color=$TRANSPARENT
    fi

    sketchybar --set space.$sid icon=${WORKSPACE_ICONS["$i"]}
done
