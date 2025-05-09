#!/bin/bash

# LightDM Lock Screen
sudo cp $HOME/.config/i3/wallpaper/current_wallpaper.jpg /usr/share/endeavouros/backgrounds/current_wallpaper.jpg
sudo cp $HOME/.config/i3/wallpaper/LockScreenConfig/slick-greeter.conf /etc/lightdm/slick-greeter.conf
echo "Complete"

# NEW_WALLPAPER="/usr/share/endeavouros/backgrounds/current_wallpaper.jpg"
# sudo sed -i "s|^background=.*|background=$NEW_WALLPAPER|" /etc/lightdm/slick-greeter.conf
# sudo sed -i "s|^draw-grid=true|draw-grid=false|" /etc/lightdm/slick-greeter.conf
