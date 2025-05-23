#!/bin/bash

theme="$HOME/.config/rofi/bluetooth/bluetooth.rasi"
# icon_device_con=""
# icon_device_discon=""
icon_device_con="󰂰"
icon_device_discon="󰂲"
display_list=()     # This list is used for frontend in rofi
mac_addr_list=()    # This list is used for backend connectivity with MAC addresses.
rofi_mesg="Bluetooth status unknown."

bluetooth_enabled() {
    bluetoothctl show | grep -q "Powered: yes"
}

toggle_bluetooth_power() {
    if bluetooth_enabled; then
        bluetoothctl power off
    else
        bluetoothctl power on
    fi
}

# Retrieves the battery percentage of a Bluetooth device using its MAC address, if available.
get_battery() {
    local mac="$1"
    battery_line=$(bluetoothctl info "$mac" | grep -Po 'Battery Percentage:\s*0x[0-9a-fA-F]+\s*\(\K\d+(?=\))')
    if [[ -n "$battery_line" ]]; then
        printf "%s%%\n" "${battery_line}"
    fi
}

# Checks whether a device with the given MAC address is currently connected.
get_connection_status() {
    local mac="$1"
    if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
        printf "yes\n"
    else
        printf "no\n"
    fi
}

# sets the rofi message based on Bluetooth state.
set_rofi_mesg() {
    if bluetooth_enabled; then
        rofi_mesg="Bluetooth enabled (Ctrl+Enter)"
    else
        rofi_mesg="Bluetooth <span foreground='red'><b>disabled</b></span> (Ctrl+Enter)"
    fi
}

# Populates the display and MAC address lists with paired Bluetooth devices.
populate_device_lists() {
    mapfile -t paired_devices_output < <(bluetoothctl devices Paired)
    if [ ${#paired_devices_output[@]} -eq 0 ]; then
        display_list+=("  No paired devices found.")
        mac_addr_list+=("")
    else
        for line in "${paired_devices_output[@]}"; do # Still show list when bluetooth is disabled.
            mac=$(printf "%s\n" "$line" | awk '{print $2}')
            name=$(printf "%s\n" "$line" | cut -d ' ' -f 3-)
            battery=$(get_battery "$mac")
            battery_str=""
            if [ -n "$battery" ]; then
                battery_str=" ($battery)"
            fi
            icon="$icon_device_discon"
            if bluetooth_enabled; then
                if [ "$(get_connection_status "$mac")" = "yes" ]; then
                    icon="$icon_device_con"
                fi
            fi
            entry="$icon   $name$battery_str"
            display_list+=("$entry")
            mac_addr_list+=("$mac")
        done
    fi
}

rofi_cmd() {
    rofi -dmenu -i \
        -mesg "$rofi_mesg" \
        -theme $theme \
        -kb-accept-custom '' \
        -kb-custom-1 'Control+Return' \
        -format 's'
}


# Setup for rofi.
populate_device_lists
set_rofi_mesg

# Run rofi
choice=$(printf "%s\n" "${display_list[@]}" | rofi_cmd)
rofi_exit_code=$?

# Ctrl + Enter to toggle bluetooth
if [ "$rofi_exit_code" -eq 10 ]; then
    toggle_bluetooth_power
    exec "$0"
fi


# Do nothing
case "$choice" in
    "") exit 0 ;; # Closed menu
    *"No paired devices found."*) exit 0 ;; # Not interactive
esac


# Find the index of choice in the display_list, then grab corresponding mac from mac_list (same idx, built in parallel)
mac=""
for i in "${!display_list[@]}"; do
    if [[ "${display_list[$i]}" == "$choice" ]]; then
        mac="${mac_addr_list[$i]}"
        break
    fi
done

# MAC addr not found for chosen option. Should never happen.
if [ -z "$mac" ]; then
    printf "Error: MAC address not found for '%s'.\n" "$choice" >&2
    exit 1
fi


# Persistent connection notification. Disappears after success/fail.
# Takes roughly 40 seconds to disappear on failure.

device_name=$(bluetoothctl info "$mac" | grep "Name:" | sed 's/^\s*Name: //')
if bluetooth_enabled && bluetoothctl info "$mac" | grep -q "Connected: yes"; then
    # Show persistent 'Disconnecting...' notification and get notification ID
    notif_id=$(dunstify -u low -t 0 "Bluetooth" "Disconnecting from $device_name" -p)
    echo ${notif_id}

    # Start disconnecting and monitor output
    bluetoothctl disconnect "$mac" | while read -r line; do
        if echo "$line" | grep -qE "Disconnection successful|Failed to disconnect"; then
            dunstctl close "$notif_id" # Close notification
            break
        fi
    done
else
    # Show persistent 'Connecting...' notification and get notification ID
    notif_id=$(dunstify -u low -t 0 "Bluetooth" "Connecting to $device_name" -p)
    
    if ! bluetooth_enabled; then # enable bluetooth if not already.
        bluetoothctl power on
        sleep 1
    fi

    # Start connecting and monitor output
    bluetoothctl connect "$mac" | while read -r line; do
        if echo "$line" | grep -qE "Connection successful|Failed to connect"; then
            dunstctl close "$notif_id" # Close notification
            break
        fi
    done
fi

