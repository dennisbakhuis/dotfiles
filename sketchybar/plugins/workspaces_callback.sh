#!/bin/sh

CONFIG_FOLDER="$HOME/.config/sketchybar"
PLUGIN_FOLDER="$CONFIG_FOLDER/plugins"

source $CONFIG_FOLDER/defaults.sh

ACTIVE_WORKSPACE=$(yabai -m query --spaces --space | jq '.index')
SELECTED_WORKSPACE_SETTINGS=(
    background.color=$SPACEBG
    background.height=18
    background.corner_radius=10
)
UNSELECTED_WORKSPACE_SETTINGS=(
    background.color=$TRANSPARENT
    background.height=$ITEM_HEIGHT
    background.corner_radius=$CORNER_RADIUS
)


for i in "${!WORKSPACE_ICONS[@]}"; do
    sid=$(($i + 1))

    if [[ $sid -eq $ACTIVE_WORKSPACE ]]; then
        sketchybar --set space.$sid label=${WORKSPACE_ICONS["$i"]} "${SELECTED_WORKSPACE_SETTINGS[@]}"
    else
        sketchybar --set space.$sid label=${WORKSPACE_ICONS["$i"]} "${UNSELECTED_WORKSPACE_SETTINGS[@]}"
    fi
done

