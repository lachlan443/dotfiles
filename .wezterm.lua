-- Import the wezterm module
local wezterm = require 'wezterm'
-- Creates a config object which we will be adding our config to
local config = wezterm.config_builder()

config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Tokyo Night'
config.colors = {
   foreground = "#FFFFFF", -- white font color
}

return config
