#!/bin/sh

CONFIG_FOLDER="$HOME/.config/sketchybar"
PLUGIN_FOLDER="$CONFIG_FOLDER/plugins"

source $CONFIG_FOLDER/defaults.sh           # create bar + set defaults

ACTIVE_WORKSPACE=$(yabai -m query --spaces --space | jq '.index')

add_workspaces() {
    # Helper: add_workspace
    #
    # Parameters
    # ----------
    # $1: side : string
    #   Side of the bar to add the workspace to, e.g. "left", "right", or "center".
    #
    # Example usage of the function:
    #   add_workspace left

    local side="${1:-left}"

    space=(
        script="$PLUGIN_FOLDER/workspaces_callback.sh"
        background.height=$ITEM_HEIGHT
        icon.drawing=off
        label.drawing=on
        label.padding_left=12
        label.padding_right=12
        label.align=center
        label.font="$GLYPH_FONT"
        label.font.size=$FONT_SIZE_GLYPHS
        label.y_offset=1
        update_freq=0
    )
    
    declare -a spacesArray=()
    for i in "${!WORKSPACE_ICONS[@]}"; do
        sid=$(($i + 1))
        spacesArray+=("space.$sid")
        
        sketchybar --add space space.$sid $side \
            --set space.$sid associated_space=$sid \
            label=${WORKSPACE_ICONS["$i"]} \
            click_script="yabai -m space --focus $sid" "${space[@]}"
        
        if [[ $sid -eq $ACTIVE_WORKSPACE ]]; then
          sketchybar --set space.$sid "${SELECTED_WORKSPACE_SETTINGS[@]}"
        fi
    
        # when workspace is 1 or 10 add addtional padding
        if [[ $sid -eq 1 ]]; then
          sketchybar --set space.$sid background.padding_left=4
        fi
        if [[ $sid -eq 10 ]]; then
          sketchybar --set space.$sid background.padding_right=4
        fi
    done
    
    sketchybar --add bracket workspaces "${spacesArray[@]}" \
      --set workspaces "${BRACKET_SETTINGS[@]}"
}

