#!/usr/bin/env bash


dir="$HOME/.config/rofi/"
theme='drun'

## Run
rofi \
  -show drun \
  -calc-command "echo '{result}' | xclip -selection clipboard && notify-send \"Copied Result\" \"{result}\"" \
  -kb-mode-next "Alt+Right" \
  -kb-mode-previous "Alt+Left" \
  -theme $HOME/.config/rofi/launcher.rasi


# rofi -list-keybindings