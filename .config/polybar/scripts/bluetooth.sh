#!/bin/bash

bluetooth_icon=""
disconnected_icon=""

# Count how many paired devices are currently connected
num_connected_devices=$(bluetoothctl devices | cut -d ' ' -f2 | while read -r mac; do
    if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
        echo "$mac"
    fi
done | wc -l)

if [[ "$num_connected_devices" -gt 0 ]]; then
    echo "%{A1:blueman-manager &:}$bluetooth_icon%{A}"
    # echo "%{A1:blueman-manager &:}$bluetooth_icon ($num_connected_devices)%{A}"
else
    echo "%{A1:blueman-manager &:}$disconnected_icon%{A}"
fi


# Don't remember what was wrong with this code
# Might as well leave it here.

# connected_devices=$(bluetoothctl info | grep -c "Connected: yes")
# if [[ "$connected_devices" -gt 0 ]]; then
#     echo "%{A1:blueman-manager &:}$bluetooth_icon ($connected_devices)%{A}"
# else
#     echo "%{A1:blueman-manager &:}$disconnected_icon%{A}"
# fi
