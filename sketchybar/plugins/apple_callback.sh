#!/bin/sh

COUNT=$(brew outdated | wc -l | tr -d ' ')
sketchybar --set apple.popup.brew label="Homebrew ($COUNT)"

