#!/bin/sh

CONFIG_FOLDER="$HOME/.config/sketchybar"
PLUGIN_FOLDER="$CONFIG_FOLDER/plugins"

source $CONFIG_FOLDER/defaults.sh


ITEM_DISTANCE=6

#############
# Date/Time #
#############
datetime=(
    update_freq=1
    script="$PLUGIN_FOLDER/datetime_callback.sh"
    icon.drawing=off
    label.font="$GLYPH_FONT"
    label.font.size=$FONT_SIZE_TEXT
    label.padding_left=15
    label.padding_right=10
    background.corner_radius=$CORNER_RADIUS
    background.color=$TEMPUS
    background.height=$ITEM_HEIGHT
    background.border_color=$PURPLE
    background.padding_left=$ITEM_DISTANCE
    background.padding_right=$BORDER_WIDTH
)
sketchybar --add item datetime right \
  --set datetime "${datetime[@]}" \
  --subscribe datetime system_woke


########
# Wifi #
########
wifi=(
    script="$PLUGIN_FOLDER/wifi_callback.sh"
    click_script="sketchybar --set wifi popup.drawing=toggle"
    update_freq=30
    icon.drawing=off
    background.padding_left=$ITEM_DISTANCE
    label.font="$GLYPH_FONT"
    label.font.size=$FONT_SIZE_GLYPHS
)
rm -f /tmp/sketchybar_speed
rm -f /tmp/sketchybar_wifi
sketchybar --add item wifi right \
  --set wifi "${wifi[@]}" \
  --subscribe wifi system_woke

# Popup menu
popup_defaults=(
    icon.font="$GLYPH_FONT"
    icon.font.size=$FONT_SIZE_GLYPHS
    label.font="$GLYPH_FONT"
    label.font.size=$FONT_SIZE_TEXT
    icon.padding_left=10
    label.padding_left=10
    label.padding_right=10
    blur_radius=100
)

ssid=(
    icon=$ICON_NETWORK
    click_script="open /System/Library/PreferencePanes/Network.prefPane/; $POPUP_OFF"
)
sketchybar --add item wifi.ssid popup.wifi \
  --set wifi.ssid "${popup_defaults[@]}" "${ssid[@]}"

ip=(
    icon=$ICON_IP
    click_script="open /System/Library/PreferencePanes/Network.prefPane/; $POPUP_OFF"
)
sketchybar --add item wifi.ip popup.wifi \
  --set wifi.ip "${popup_defaults[@]}" "${ip[@]}"

speed=(
    icon=$ICON_SPEED
    update_freq=10
    width=125
    script="$PLUGIN_FOLDER/speed_callback.sh"
)
sketchybar --add item wifi.speed popup.wifi \
  --set wifi.speed "${popup_defaults[@]}" "${speed[@]}"


###########
# Battery #
###########
battery=(
    script="$PLUGIN_FOLDER/battery_callback.sh"
    update_freq=120
    icon.font="$GLYPH_FONT"
    icon.font.size=$FONT_SIZE_GLYPHS
    label.font="$GLYPH_FONT"
    label.font.size=$FONT_SIZE_TEXT
    click_script="sketchybar --set battery popup.drawing=toggle"
    label.padding_left=2
    background.padding_left=$ITEM_DISTANCE
)
sketchybar --add item battery right \
  --set battery "${battery[@]}" \
  --subscribe battery power_source_change system_woke


##########
# Volume #
##########
volume=(
  script="$PLUGIN_FOLDER/volume_callback.sh"
  updates=on
  label.drawing=off
  icon.drawing=off
  slider.highlight_color=$PURPLE
  slider.background.height=5
  slider.background.corner_radius=3
  slider.background.color=$GREY
  slider.knob=$DOT
  slider.knob.drawing=off
  # label.padding_left=10
  background.color=$STATUS
  background.height=10
  background.corner_radius=10
  background.border_width=2
  background.border_color=$PURPLE
  # background.padding_right=7
)
sketchybar --add slider volume right \
  --set volume "${volume[@]}" \
  --subscribe volume volume_change mouse.clicked mouse.entered mouse.exited

volume_icon=(
    click_script="$PLUGIN_FOLDER/volume_click.sh"
    label.padding_right=8
    label.padding_left=10
    label.font="$GLYPH_FONT"
    label.font.size=$FONT_SIZE_GLYPHS
    width=16
)
sketchybar --add item volume_icon right \
  --set volume_icon "${volume_icon[@]}"

# Bracket around whole connectivity bar
sketchybar --add bracket connectivity datetime wifi battery volume_icon \
  --set connectivity "${BRACKET_SETTINGS[@]}"

