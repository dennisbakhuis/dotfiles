#!/bin/sh

# Make sure to source icons.sh before this file.

WORKSPACE_ICONS=(
    "$WORK" 
    "$BROWSER" 
    "$MUSIC" 
    "$UNI" 
    "$MAIL" 
    "$GENERAL" 
    "$GENERAL" 
    "$GENERAL" 
    "$GENERAL"
    "$GENERAL"
)

ACTIVE_WORKSPACE=$(yabai -m query --spaces --space | jq '.index')

SELECTED_WORKSPACE_SETTINGS=(
  background.color=$SPACEBG
  background.height=18
  background.corner_radius=10
)

