#!/bin/bash

theme=$HOME/.config/rofi/powermenu/powermenu.rasi


# Options
 shutdown='  Shutdown'
   reboot='  Reboot'
     lock='  Lock'
  suspend='  Suspend'
hibernate='  Hibernate'
   logout='  Logout'

# Rofi CMD for normal mode
rofi_cmd() {
    rofi -dmenu \
        -selected-row 2 \
        -theme $theme
}


# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-selected-row 2 \
        -mesg "test" \
		-theme $theme
}

# Rofi CMD for taskbar mode (override theme for SE location)
rofi_cmd_taskbar() {
    rofi -dmenu \
        -selected-row 2 \
		-theme $theme \
        -theme-str 'window {location: southeast; anchor: southeast; fullscreen: false; width: 10%; y-offset: -60px;}'
}


# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$logout\n$suspend\n$lock\n$reboot\n$shutdown\n$hibernate" | rofi_cmd
}
run_rofi_taskbar() {
	echo -e "$logout\n$suspend\n$lock\n$reboot\n$shutdown\n$hibernate" | rofi_cmd_taskbar
}


# Parse argument: if --taskbar, use taskbar mode; else normal
if [[ "$1" == "--taskbar" ]]; then
    chosen="$(run_rofi_taskbar)"
else
    chosen="$(run_rofi)"
fi

# Actions
# chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		systemctl poweroff
        ;;
    $reboot)
		systemctl reboot
        ;;
    $lock)
		dm-tool lock
        ;;
    $suspend)
		playerctl pause
		amixer set Master mute
		systemctl suspend
        ;;
    $logout)
		i3-msg exit
        ;;
	$hibernate)
		playerctl pause
		amixer set Master mute
		systemctl hibernate
		;;
esac
