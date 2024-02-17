#!/bin/sh

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/workspaces.sh"

PLUGIN_DIR=${PLUGIN_DIR:-"$HOME/.config/sketchybar/plugins"}

space=(
  script="$PLUGIN_DIR/workspaces_callback.sh"
  label.drawing=off
  icon.padding_left=15
  icon.padding_right=15
  update_freq=1
)

declare -a spacesArray=()
for i in "${!WORKSPACE_ICONS[@]}"; do
    sid=$(($i + 1))
    spacesArray+=("space.$sid")
    
    sketchybar --add space space.$sid left \
        --set space.$sid associated_space=$sid \
        icon=${WORKSPACE_ICONS["$i"]} \
        click_script="yabai -m space --focus $sid" "${space[@]}"
    
    if [[ $sid -eq $ACTIVE_WORKSPACE ]]; then
      sketchybar --set space.$sid "${SELECTED_WORKSPACE_SETTINGS[@]}"
    fi
done

brackets=(
    background.color=$STATUS
    background.height=25
    background.corner_radius=$CORNER_RADIUS
    background.border_color=$PURPLE
    background.border_width=$BORDER_WIDTH
)

sketchybar --add bracket control "${spacesArray[@]}" center \
  --set control "${brackets[@]}"

