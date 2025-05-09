#!/bin/bash

echo "🔧 Updating LightDM background wallpaper..."

sudo cp $HOME/.config/wallpaper/current_wallpaper.jpg /usr/share/endeavouros/backgrounds/
NEW_WALLPAPER="/usr/share/endeavouros/backgrounds/current_wallpaper.jpg"
sudo sed -i "s|^background=.*|background=$NEW_WALLPAPER|" /etc/lightdm/slick-greeter.conf
sudo sed -i "s|^draw-grid=true|draw-grid=false|" /etc/lightdm/slick-greeter.conf

echo "✅ Wallpaper updated successfully."