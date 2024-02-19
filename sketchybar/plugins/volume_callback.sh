#!/bin/sh

source "$HOME/.config/sketchybar/icons.sh"

export ICON_VOLUME_MUTE=󰖁
export ICON_VOLUME_LOW=
export ICON_VOLUME_MEDIUM=󰖀
export ICON_VOLUME_HIGH=󰕾

volume_change() {
  case $INFO in
  [6-9][0-9] | 100)
    ICON=$ICON_VOLUME_HIGH
    ;;
  [3-5][0-9])
    ICON=$ICON_VOLUME_MEDIUM
    ;;
  [1-2][0-9])
    ICON=$ICON_VOLUME_LOW
    ;;
  [1-9])
    ICON=$ICON_VOLUME_LOW
    ;;
  0)
    ICON=$ICON_VOLUME_MUTE
    ;;
  *) ICON=$ICON_VOLUME_HIGH ;;
  esac

  sketchybar --set volume_icon label=$ICON

  sketchybar --set $NAME slider.percentage=$INFO \
    --animate tanh 30 --set $NAME slider.width=100

  sleep 2

  FINAL_PERCENTAGE=$(sketchybar --query $NAME | jq -r ".slider.percentage")
  if [ "$FINAL_PERCENTAGE" -eq "$INFO" ]; then
    sketchybar --animate tanh 30 --set $NAME slider.width=0
  fi
}

mouse_clicked() {
  osascript -e "set volume output volume $PERCENTAGE"
}

mouse_entered() {
  sketchybar --set $NAME slider.knob.drawing=on
}

mouse_exited() {
  sketchybar --set $NAME slider.knob.drawing=off
}

case "$SENDER" in
"volume_change")
  volume_change
  ;;
"mouse.clicked")
  mouse_clicked
  ;;
"mouse.entered")
  mouse_entered
  ;;
"mouse.exited")
  mouse_exited
  ;;
esac
