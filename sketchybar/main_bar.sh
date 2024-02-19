#!/bin/sh
CONFIG_FOLDER="$HOME/.config/sketchybar"
PLUGIN_FOLDER="$CONFIG_FOLDER/plugins"

source $CONFIG_FOLDER/defaults.sh           # load constants

##################
# Create top bar #
##################
bar=(
    position=top
    height=36
    margin=-10
    color=$TRANSPARENT
    y_offset=2
    sticky=off
    notch_width=250
)

sketchybar --bar "${bar[@]}"

# Set defaults
defaults=(
    updates=when_shown
    icon.drawing=on
    icon.font="$GLYPH_FONT"
    icon.color=$WHITE
    label.font="$GLYPH_FONT"
    label.drawing=on
    label.color=$WHITE
    popup.background.color=$BLUE
    popup.background.corner_radius=$CORNER_RADIUS
    popup.background.border_width=$BORDER_WIDTH
    popup.background.border_color=$PURPLE
    popup.blur_radius=100
    background.height=$ITEM_HEIGHT
    background.corner_radius=$CORNER_RADIUS
    label.padding_left=0
    label.padding_right=0
    background.padding_left=0
    background.padding_right=0
    icon.padding_left=0
    icon.padding_right=0
)

sketchybar --default "${defaults[@]}"

