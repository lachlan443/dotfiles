#!/bin/bash


dir="$HOME/.config/rofi/"
theme='drun'

## Run
rofi \
  -show drun \
  -theme $HOME/.config/rofi/launcher/launcher.rasi


# multi_launcher.rasi
# rofi \
#   -show drun \
#   -calc-command "echo '{result}' | xclip -selection clipboard && notify-send \"Copied Result\" \"{result}\"" \
#   -kb-mode-next "Alt+Right" \
#   -kb-mode-previous "Alt+Left" \
#   -theme $HOME/.config/rofi/launcher/multi_launcher.rasi





# rofi -list-keybindings