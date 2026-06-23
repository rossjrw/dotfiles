#!/bin/bash
# Toggle the internal display between normal and 90° (counter-clockwise) rotation.
set -euo pipefail

OUTPUT="eDP-1"
SCALE="1.7488372325897217"   # current fractional scale; keeps DPI consistent
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/screen-rotated"
RANDR="$HOME/.local/bin/gnome-randr"

if [ -f "$STATE_FILE" ]; then
    "$RANDR" --output "$OUTPUT" --rotate normal --scale "$SCALE"
    rm -f "$STATE_FILE"
else
    "$RANDR" --output "$OUTPUT" --rotate left --scale "$SCALE"
    touch "$STATE_FILE"
fi
