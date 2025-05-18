#!/bin/bash

# ~/.config/polybar/scripts/toggle_dnd.sh

level=$(dunstctl get-pause-level)

if [ "$level" -ge 10 ]; then
    dunstctl set-pause-level 0
else
    dunstctl set-pause-level 10
fi