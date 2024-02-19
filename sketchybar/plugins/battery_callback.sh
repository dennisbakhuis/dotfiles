#!/bin/sh

CONFIG_FOLDER="$HOME/.config/sketchybar"
PLUGIN_FOLDER="$CONFIG_FOLDER/plugins"

source $CONFIG_FOLDER/defaults.sh


PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

# Icons
export ICON_BATTERY_0=󰂎
export ICON_BATTERY_10=󰁺
export ICON_BATTERY_20=󰁻
export ICON_BATTERY_30=󰁼
export ICON_BATTERY_40=󰁽
export ICON_BATTERY_50=󰁾
export ICON_BATTERY_60=󰁿
export ICON_BATTERY_70=󰂀
export ICON_BATTERY_80=󰂁
export ICON_BATTERY_90=󰂂
export ICON_BATTERY_100=󰁹
export ICON_BATTERY_0_CHARGING=󰢟
export ICON_BATTERY_10_CHARGING=󰢜
export ICON_BATTERY_20_CHARGING=󰂆
export ICON_BATTERY_30_CHARGING=󰂇
export ICON_BATTERY_40_CHARGING=󰂈
export ICON_BATTERY_50_CHARGING=󰢝
export ICON_BATTERY_60_CHARGING=󰂉
export ICON_BATTERY_70_CHARGING=󰢞
export ICON_BATTERY_80_CHARGING=󰂊
export ICON_BATTERY_90_CHARGING=󰂋
export ICON_BATTERY_100_CHARGING=󰂅


ICON_BASE="ICON_BATTERY"
ICON_SEGMENT=$((PERCENTAGE / 10 * 10))

if [ "$PERCENTAGE" -gt 0 ] && [ "$PERCENTAGE" -lt 5 ]; then
  ICON_SEGMENT=0
fi

if [ "$CHARGING" != "" ]; then
  ICON_BASE="${ICON_BASE}_${ICON_SEGMENT}_CHARGING"
else
  ICON_BASE="${ICON_BASE}_${ICON_SEGMENT}"
fi

ICON_VAR_NAME=$(eval echo \$$ICON_BASE)
BATTERY_LABEL="${PERCENTAGE}%"

sketchybar --set $NAME label="$BATTERY_LABEL" icon="$ICON_VAR_NAME"

