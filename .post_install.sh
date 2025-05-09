#!/bin/bash
PACKAGE_FILE=".packages.txt"
echo "🔄 Updating package database..."
sudo pacman -Sy

echo "📦 Reading package list from $PACKAGE_FILE..."
mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$PACKAGE_FILE" | sed 's/#.*//' | xargs -n1)  # Filter comments

echo "📥 Installing packages: ${packages[*]}"
sudo pacman -S --needed --noconfirm "${packages[@]}"

echo "🔧 Creating Screenshots directory"
mkdir -p ~/Pictures/Screenshots

echo "🔧 Enabling Bluetooth"
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# echo "🔧 Starting system tray applications"
# blueman-applet &
# nm-applet &
# pasystray &
# disown

# echo "🔧 Patch Dolphin file associations"
# if [ -f /etc/xdg/menus/plasma-applications.menu ]; then
#     sudo cp /etc/xdg/menus/plasma-applications.menu /etc/xdg/menus/applications.menu
# else
#     sudo cp /etc/xdg/menus/arch-applications.menu /etc/xdg/menus/applications.menu
# fi
# kbuildsycoca6

echo "🔧 Updating LightDM background wallpaper..."
./.config/i3/wallpaper/update_lock_screen_wallpaper.sh


echo "✅ Complete"
echo "run [gh auth login] for Git"
