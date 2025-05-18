#!/bin/bash

# This script runs as a background process to monitor Spotify's playback status
# using `playerctl status --follow -p spotify`, and sends IPC updates to polybar
# to show or hide media controls based on whether it's playing, paused, or closed.


# Polybar module names
PLAY_PAUSE="#spotify-play-pause"
PREV="#spotify-prev"
NEXT="#spotify-next"


hide_controls() { # This is the fallback function.
    polybar-msg action "$PLAY_PAUSE.hook.0"
    polybar-msg action "$PREV.hook.0"
    polybar-msg action "$NEXT.hook.0"
}
show_paused() {
    polybar-msg action "$PLAY_PAUSE.hook.1"
    polybar-msg action "$PREV.hook.1"
    polybar-msg action "$NEXT.hook.1"
}
show_playing() {
    polybar-msg action "$PLAY_PAUSE.hook.2"
    polybar-msg action "$PREV.hook.1"
    polybar-msg action "$NEXT.hook.1"
}

# Start script with the correct state
initial_status=$(playerctl status -p spotify 2>/dev/null)
case "$initial_status" in
    "Playing") show_playing ;;
    "Paused") show_paused ;;
    *) hide_controls ;;
esac

# Follow status updates and react accordingly
playerctl status --follow -p spotify | while read -r status; do
    case "$status" in
        "Playing") show_playing ;;
        "Paused") show_paused ;;
        "Stopped") hide_controls ;;
        *) hide_controls ;;  # Handles unexpected output
    esac
done
