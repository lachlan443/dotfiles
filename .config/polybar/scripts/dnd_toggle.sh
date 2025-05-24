#!/bin/bash

level=$(dunstctl get-pause-level)

if [ "$level" -ge 10 ]; then
    dunstctl set-pause-level 0
    # dunstify "Do Not Disturb" "Disabled"
else
    dunstctl set-pause-level 10
    # dunstify "Do Not Disturb" "Enabled"
fi
