#!/bin/sh

CONFIG_FOLDER="$HOME/.config/sketchybar"
PLUGIN_FOLDER="$CONFIG_FOLDER/plugins"

source $CONFIG_FOLDER/defaults.sh
 
add_apple() {
    # Helper: add_apple
    #
    # Parameters
    # ----------
    # $1: side : string
    #   Side of the bar to add the apple to, e.g. "left", "right", or "center".
    #
    # Example usage of the function:
    #   add_apple right

    local side="${1:-left}"

    if [ "$side" = "right" ]; then
        local popup_side="right"
    else
        local popup_side="left"
    fi

    apple=(
        script="$PLUGIN_FOLDER/apple_callback.sh"
        update_freq=1800
        click_script="sketchybar --set apple popup.drawing=toggle"
        icon.drawing=off
        label.drawing=on
        label=$ICON_APPLE
        label.font="$GLYPH_FONT"
        label.font.size=$FONT_SIZE_GLYPHS
        label.y_offset=2
        background.height=$BRACKET_HEIGHT
        background.color=$TEMPUS
        background.corner_radius=$CORNER_RADIUS
        width=32
        align=center
        background.border_color=$PURPLE
        background.border_width=$BORDER_WIDTH
        popup.align=$popup_side
    )
    
    sketchybar --add item apple $side \
      --set apple "${apple[@]}"

    # Add the popup
    properties=(
        label.padding_left=10
        label.padding_right=10
        label.font="$GLYPH_FONT"
        icon.font="$GLYPH_FONT"
        icon.padding_left=10
        background.height=10
        blur_radius=100
        width=175
    )
    
    sketchybar --add item apple.popup.activity popup.apple \
      --set apple.popup.activity label="Activity Monitor" \
      icon=$ACTIVITY "${properties[@]}" \
      click_script="open -a 'Activity Monitor'" \
      \
      --add item apple.popup.brew popup.apple \
      --set apple.popup.brew label="Homebrew (0)" \
      icon=$BREW "${properties[@]}" \
      \
      --add item apple.popup.lock popup.apple \
      --set apple.popup.lock label="Lock Screen" \
      icon=$LOCK "${properties[@]}" \
      click_script="pmset displaysleepnow" \
      \
      --add item apple.popup.settings popup.apple \
      --set apple.popup.settings label="System Preferences" \
      icon=$PREFERENCES "${properties[@]}" \
      click_script="open -a 'System Preferences'" \
      \
      --add item apple.popup.restart popup.apple \
      --set apple.popup.restart label="Restart" \
      icon=$RESTART "${properties[@]}" \
      click_script="reboot" \
      \
      --add item apple.popup.shutdown popup.apple \
      --set apple.popup.shutdown label="Shut down" \
      icon=$OFF "${properties[@]}" \
      click_script="halt"
}
