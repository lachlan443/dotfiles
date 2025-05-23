#!/bin/bash
# Thank you beyond9thousand

hidden=/tmp/syshide.lock
file="$HOME/.config/polybar/config.ini"

if [[ $(pidof stalonetray) ]]; then
	if [[ ! -e $hidden ]]; then
		polybar-msg action "#systray.hook.0"
		xdo hide -n stalonetray
		touch "$hidden"
		# perl -0 -i -pe 's/systray\ninitial=.*/systray\ninitial=2/g' "$file"
	else
		polybar-msg action "#systray.hook.1"
		xdo show -n stalonetray
		xdo raise -n stalonetray
		rm "$hidden"
		# perl -0 -i -pe 's/systray\ninitial=.*/systray\ninitial=1/g' "$file"
	fi
else
	stalonetray &
fi