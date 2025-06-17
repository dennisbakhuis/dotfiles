#!/bin/sh
# Based on: https://github.com/koekeishiya/yabai/issues/1225#issuecomment-1937400050

setup_space() {
	local idx="$1"
	local name="$2"
	local display="$3"
	local mode="$4"
	local space=
	echo "setup space $idx : $name on display $display in mode $mode"

	space=$(yabai -m query --spaces --space "$idx")
	if [ -z "$space" ]; then
		yabai -m space --create
	fi

	yabai -m space "$idx" --label "$name"
	yabai -m space "$idx" --display "$display"
	yabai -m space "$idx" --layout "$mode"
}

number_of_screens=$(yabai -m query --displays | jq '. | length')
number_of_spaces=$(yabai -m query --spaces | jq '. | length')

echo "number_of_screens: $number_of_screens"
echo "number_of_spaces: $number_of_spaces"

# Set Up Main screen Spaces (base setup)
setup_space 1 terminal 1 bsp
setup_space 2 web 1 bsp
setup_space 3 code 1 bsp
setup_space 4 work 1 bsp
setup_space 5 play 1 bsp
setup_space 6 notes 1 bsp
setup_space 7 chat 1 bsp
setup_space 8 mail_work 1 bsp
setup_space 9 mail_work 1 bsp

if [ "$number_of_screens" -eq 1 ] && [ "$number_of_spaces" -eq 10 ]; then
	echo "destroying space 10"
	yabai -m space --destroy 10
elif [ "$number_of_screens" -eq 2 ]; then
	sleep 1
	echo "setting up second screen spaces"
	setup_space 10 large_screen 2 float
fi
