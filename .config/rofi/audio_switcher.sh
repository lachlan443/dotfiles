#!/bin/bash

# Theme file
theme="$HOME/.config/rofi/audio/audio_switcher.rasi"

# Icons
icon_active=""   # Checkmark

# Data structures
declare -A SINK_MAP
sink_list=()

# Function to get rofi command with theme
rofi_cmd() {
    rofi -dmenu -i \
        -theme $theme
}

get_default_sink_name() {
    pactl info | grep "Default Sink" | awk -F": " '{print $2}'
}

get_sinks() {
    default_sink=$(get_default_sink_name)
    mapfile -t sink_lines < <(pactl list short sinks)

    for line in "${sink_lines[@]}"; do
        sink_name=$(echo "$line" | awk '{print $2}')
        desc=$(pactl list sinks | awk -v RS= "/Name: $sink_name/" | grep 'Description:' | cut -d ':' -f2- | xargs)
        
        if [[ "$sink_name" == "$default_sink" ]]; then
            display_desc="$icon_active $desc"
            sink_list=("$display_desc" "${sink_list[@]}")
        else
            display_desc="$desc"
            sink_list+=("$display_desc")
        fi

        SINK_MAP["$display_desc"]="$sink_name"
    done
}

run_rofi() {
    get_sinks
    chosen_desc=$(printf "%s\n" "${sink_list[@]}" | rofi_cmd)

    if [ -n "$chosen_desc" ]; then
        chosen_sink="${SINK_MAP[$chosen_desc]}"
        pactl set-default-sink "$chosen_sink"
        for input in $(pactl list short sink-inputs | awk '{print $1}'); do
            pactl move-sink-input "$input" "$chosen_sink"
        done
    fi
}

run_rofi