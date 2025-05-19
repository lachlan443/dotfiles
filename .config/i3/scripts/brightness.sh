#!/bin/bash
# original source: https://gitlab.com/Nmoleo/i3-volume-brightness-indicator

# Default to 10 if no input
brightness_step=${2:-10}
notification_timeout=1000


if [[ "$1" == "-h" || "$1" == "--help" || -z "$1" ]]; then
    echo "Usage: $0 {up|down} [step]"
    echo ""
    echo "  step: optional integer specifying step size (default 10)"
    exit 1
fi

# Uses brightnessctl to get current brightness as a percentage
function get_brightness {
    brightnessctl get | awk -v max=$(brightnessctl max) '{printf "%d\n", ($1 * 100 / max)}'
}


# function get_brightness_icon {
#     brightness_icon=""
# }
function get_brightness_icon {
    local brightness=$(get_brightness)

    if [ "$brightness" -eq 0 ]; then
        echo "󰖨"
    elif [ "$brightness" -lt 30 ]; then
        echo "󰃞"
    elif [ "$brightness" -lt 70 ]; then
        echo "󰃟"
    else
        echo "󰃠"
    fi
}


# Displays a brightness notification using dunstify with persistent ID
function show_brightness_notif {
    local brightness=$(get_brightness)
    local brightness_icon=$(get_brightness_icon)
    dunstify -r 9992 -t $notification_timeout \
        -h string:category:brightness \
        -h int:value:$brightness \
        "$brightness_icon    $brightness%"
}

# Main function - Takes user input "up" or "down"
case $1 in
    up)
        brightness=$(get_brightness)
        if [ $(( brightness + brightness_step )) -gt 100 ]; then
            brightnessctl set 100%
        else
            brightnessctl set ${brightness_step}%+
        fi
        show_brightness_notif
        ;;

    down)
        brightness=$(get_brightness)
        if [ $(( brightness - brightness_step )) -lt 0 ]; then
            brightnessctl set 0%
        else
            brightnessctl set ${brightness_step}%- 
        fi
        show_brightness_notif
        ;;
esac
