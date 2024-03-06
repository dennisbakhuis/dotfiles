#!/bin/sh
# Based on: https://github.com/koekeishiya/yabai/issues/1225#issuecomment-1937400050

setup_space() {
	local idx="$1"
	local name="$2"
	local display="$3"
	local space=
	echo "setup space $idx : $name on display $display"

	space=$(yabai -m query --spaces --space "$idx")
	if [ -z "$space" ]; then
		yabai -m space --create
	fi

	yabai -m space "$idx" --label "$name"
	yabai -m space "$idx" --display "$display"
}

number_of_screens=$(yabai -m query --displays | jq '. | length')
delete_up_to=$((number_of_screens + 7))

echo "number_of_screens: $number_of_screens"
echo "delete_up_to: $delete_up_to"

# Setup or destroy spaces as needed to match 9
for _ in $(yabai -m query --spaces | jq ".[].index | select(. > $delete_up_to )"); do
	yabai -m space --destroy 10
done

# Set Up Main screen Spaces
setup_space 1 terminal 1
setup_space 2 web 1
setup_space 3 code 1
setup_space 4 work 1
setup_space 5 play 1
setup_space 6 notes 1
setup_space 7 chat 1
setup_space 8 mail 1

# Set up second screen if present by checking leng
if [ "$number_of_screens" -gt 1 ]; then
	setup_space 9 second_work 2
	setup_space 10 second_play 2
fi
