#!/bin/bash

DIR=~/Pictures/Screenshots
mkdir -p "$DIR"
FILENAME="$DIR/$(date "+%Y-%m-%d-%H%M%S")-screenshot.png"

scrot "$FILENAME" || exit 1

# # Use dunstify with an action
# ACTION=$(dunstify -A open_dolphin,"Open Location" "Screenshot saved" "$(basename "$FILENAME")")

# Show notification with screenshot preview and an action button
ACTION=$(dunstify \
    -i "$FILENAME" \
    -A open_dolphin,"Open Location" \
    "Screenshot saved" "$(basename "$FILENAME")")

# If user clicks the action
if [[ "$ACTION" == "open_dolphin" ]]; then
    dolphin --select "$FILENAME"
fi


