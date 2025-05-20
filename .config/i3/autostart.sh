#!/bin/bash

# Start stalonetray if not already running
if [[ ! $(pidof stalonetray) ]]; then
    stalonetray &
    sleep 0.5
    xdo hide -N stalonetray
    touch "/tmp/syshide.lock"
fi

# Start background apps
1password --silent &

xfce4-power-manager &

xinput set-prop "Microsoft Surface 045E:09AF Touchpad" "libinput Accel Speed" 0.5 &