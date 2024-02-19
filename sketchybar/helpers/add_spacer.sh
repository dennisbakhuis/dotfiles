#!/bin/sh

add_spacer() {
    # Helper: add_spacer
    #
    # Parameters
    # ----------
    # $1: identifier : string
    #   Identifier of the spacer, e..g "spacer1"
    # $2: side : string
    #   Side of the bar to add the spacer to, e.g. "left", "right", or "center".
    #   Default is "left".
    # $3: width : int
    #   Width of the spacer in pixels. Default is 8.
    #
    # Example usage of the function:
    #   add_spacer <identifier> [side] [width]
    #   add_spacer spacer1 right 18

    local identifier="$1"
    local side="${2:-left}" # Default side is left if not specified
    local width="${3:-8}" # Default width is 8 if not specified

    sketchybar --add item "$identifier" "$side" \
        --set "$identifier" width="$width"
}

