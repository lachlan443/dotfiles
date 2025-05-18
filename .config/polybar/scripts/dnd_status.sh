#!/bin/bash

# ~/.config/polybar/scripts/dnd_status.sh

level=$(dunstctl get-pause-level)

if [ "$level" -ge 10 ]; then
    echo "󰂛"  # DND on
else
    echo "󰂜"  # DND off
fi