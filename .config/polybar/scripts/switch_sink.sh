#!/bin/bash

# Get list of sinks with their index and human-readable description
mapfile -t sink_lines < <(pactl list short sinks)
declare -A sink_map

for line in "${sink_lines[@]}"; do
    sink_index=$(echo "$line" | awk '{print $1}')
    sink_name=$(echo "$line" | awk '{print $2}')
    desc=$(pactl list sinks | awk -v RS= "/Name: $sink_name/" | grep 'Description:' | cut -d ':' -f2- | xargs)
    sink_map["$desc"]="$sink_name"
done

# Show menu of descriptions
chosen_desc=$(printf "%s\n" "${!sink_map[@]}" | rofi -dmenu -p "Select audio sink:")

# Set selected sink as default and move audio
if [ -n "$chosen_desc" ]; then
    chosen_sink="${sink_map[$chosen_desc]}"
    pactl set-default-sink "$chosen_sink"
    for input in $(pactl list short sink-inputs | awk '{print $1}'); do
        pactl move-sink-input "$input" "$chosen_sink"
    done
fi