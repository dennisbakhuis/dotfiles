#!/bin/sh

CONFIG_FOLDER="$HOME/.config/sketchybar"
PLUGIN_FOLDER="$CONFIG_FOLDER/plugins"

source $CONFIG_FOLDER/defaults.sh           # load constants


CURRENT_WIFI="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)"
SSID="$(echo "$CURRENT_WIFI" | grep -o "SSID: .*" | sed 's/^SSID: //')"
sketchybar --set wifi.ssid label="$SSID"

WIFI_INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
IP_ADDR=$(ipconfig getifaddr $WIFI_INTERFACE)
sketchybar --set wifi.ip label="$IP_ADDR"

if [ ! -f /tmp/sketchybar_wifi ]; then
  touch /tmp/sketchybar_wifi
fi

if [ ! -f /tmp/sketchybar_speed ]; then
  (
    COUNTER=0
    END_TIME=$(($(date +%s) + 9))
    while [ $(date +%s) -lt $END_TIME ]; do
      case $COUNTER in
        0) LABEL="Loading." ;;
        1) LABEL="Loading.." ;;
        2) LABEL="Loading..." ;;
      esac
      sketchybar --set wifi.speed label="$LABEL"
      sleep 1
      COUNTER=$(((COUNTER + 1) % 3))
    done
  ) &
fi

WIFI_INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
WIFI_POWER=$(networksetup -getairportpower $WIFI_INTERFACE | awk '{print $4}')
if [ "$WIFI_POWER" == "Off" ]; then
  sketchybar --set $NAME label=$ICON_WIFI_OFF
  exit 0
fi

SSID_LOWER=$(echo "$SSID" | tr '[:upper:]' '[:lower:]')
if [[ "$SSID_LOWER" == *iphone* ]]; then
  sketchybar --set $NAME label=$ICON_WIFI_HOTSPOT
  exit 0
fi

CURR_TX="$(echo "$CURRENT_WIFI" | grep -o "lastTxRate: .*" | sed 's/^lastTxRate: //')"
if [ $CURR_TX = 0 ]; then
  sketchybar --set $NAME label=$ICON_WIFI_NO_INTERNET
  exit 0
fi

sketchybar --set $NAME label=$ICON_WIFI

