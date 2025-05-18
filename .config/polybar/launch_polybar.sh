#!/usr/bin/env sh

# # Terminate already running bar instances
# killall -q polybar

# # Wait until the processes have been shut down
# while pgrep -x polybar >/dev/null; do sleep 1; done

# # Launch polybar
# polybar desktop &


# #!/usr/bin/env sh

# --- Kill all existing Polybar instances ---
killall -q polybar

# --- Kill existing Spotify daemon ---
pkill -f spotify_event_listener.sh

# --- Wait until Polybar has fully shut down ---
while pgrep -x polybar >/dev/null; do sleep 1; done

# --- Launch Polybar ---
polybar desktop &

# --- Start Spotify daemon ---
$HOME/.config/polybar/scripts/spotify_event_listener.sh &
