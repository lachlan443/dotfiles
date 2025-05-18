#!/bin/bash
# original source: https://gitlab.com/Nmoleo/i3-volume-brightness-indicator


# Default to 5 if no input
volume_step=${2:-5}
max_volume=100
notification_timeout=1000


# Usage
if [[ "$1" == "-h" || "$1" == "--help" || -z "$1" ]]; then
    echo "Usage: $0 {up|down} [step]"
    echo "       $0 mute "
    echo ""
    echo "  step: optional integer specifying step size (default 5)"
    exit 1
fi

# Uses regex to get volume from pactl
function get_volume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

# Uses regex to get mute status from pactl
function get_mute {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}

function get_volume_icon {
    local volume=$(get_volume)
    local mute=$(get_mute)

    if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ]; then
        echo ""
    elif [ "$volume" -lt 50 ]; then
        echo ""
    else
        echo ""
    fi
}

# Displays a volume notification using dunstify with persistent ID
function show_volume_notif {
    local volume=$(get_volume)
    local mute_status=$(get_mute)
    local notification_message

    if [ "$mute_status" = "yes" ]; then
        # If muted, display "Muted (volume%)"
        notification_message="Muted ($volume%)"
    else
        # If not muted, display "icon volume%"
        local volume_icon=$(get_volume_icon)
        notification_message="$volume_icon    $volume%"
    fi

    dunstify -r 9991 -t "$notification_timeout" \
        -h string:category:volume \
        -h int:value:"$volume" \
        "$notification_message"
}


# Main function - Takes user input "up", "down", or "mute"
case $1 in
    up)
        # pactl set-sink-mute @DEFAULT_SINK@ 0
        volume=$(get_volume)
        if [ $(( "$volume" + "$volume_step" )) -gt $max_volume ]; then
            pactl set-sink-volume @DEFAULT_SINK@ $max_volume%
        else
            pactl set-sink-volume @DEFAULT_SINK@ +$volume_step%
        fi
        show_volume_notif
        ;;
    
    down)
        # pactl set-sink-mute @DEFAULT_SINK@ 0
        volume=$(get_volume)
        if [ $(( volume - volume_step )) -lt 0 ]; then
            pactl set-sink-volume @DEFAULT_SINK@ 0%
        else
            pactl set-sink-volume @DEFAULT_SINK@ -${volume_step}%
        fi
        show_volume_notif
        ;;

    mute)
        # Toggles mute and displays the notification
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        show_volume_notif
        ;;
esac
