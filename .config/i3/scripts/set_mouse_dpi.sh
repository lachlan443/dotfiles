#!/bin/bash

# List all the devices that are mice
mice=$(ratbagctl list | grep -o '^[^:]*')

# Set DPI to 800 for each mouse
for mouse in $mice; do
  ratbagctl "$mouse" dpi set 800
done

# Disable mouse acceleration using xset
xset m 1/1 0
