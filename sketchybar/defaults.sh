#!/bin/sh

CONFIG_FOLDER="$HOME/.config/sketchybar"
PLUGIN_FOLDER="$CONFIG_FOLDER/plugins"
HELPER_FOLDER="$CONFIG_FOLDER/helpers"

source $CONFIG_FOLDER/colors.sh


####################
# Default settings #
####################
ITEM_HEIGHT=22
BRACKET_HEIGHT=26
CORNER_RADIUS=10
BORDER_WIDTH=2
GLYPH_FONT="FiraCode Nerd Font Mono:Regular:12.0"
FONT_SIZE=20
FONT_SIZE_GLYPHS=20
FONT_SIZE_TEXT=13


BRACKET_SETTINGS=(
    background.color=$STATUS
    background.height=$BRACKET_HEIGHT
    background.corner_radius=$CORNER_RADIUS
    background.border_color=$PURPLE
    background.border_width=$BORDER_WIDTH
)

#########
# Icons #
#########
export ICON_APPLE=

# Workspaces
export ICON_TERMINAL=
export ICON_CODE=
export ICON_BROWSER=󰖟
export ICON_CODE_SPACE=
export ICON_PYTHON=
export ICON_TOY=󱊍
export ICON_CONTROL=
export ICON_MUSIC=󰝚
export ICON_CHAT=󰭹
export ICON_MAIL=
export ICON_NOTE=

# Connectivity - wifi
export ICON_WIFI=󰤨
export ICON_WIFI_NO_INTERNET=󰤫
export ICON_WIFI_HOTSPOT=󱚸
export ICON_WIFI_OFF=󱚼
export ICON_NETWORK=󰀂
export ICON_SPEED=󰓅
export ICON_IP=󰩠

# Connectivity - battery
# Icons in battery_callback.sh

# Connectivity - volume
# Icons in volume_callback.sh



##############
# Workspaces #
##############
# To reduce workspaces, remove the corresponding line from the array
WORKSPACE_ICONS=(
    "$ICON_TERMINAL" 
    "$ICON_CODE" 
    "$ICON_BROWSER" 
    "$ICON_CODE_SPACE"
    "$ICON_PYTHON" 
    "$ICON_TOY"
    "$ICON_CONTROL"
    "$ICON_NOTE"
    "$ICON_CHAT"
    "$ICON_MAIL"
)


####################
# Helper functions #
####################
for file in $HELPER_FOLDER/*.sh; do
    source $file
done

