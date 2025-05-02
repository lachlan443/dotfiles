-- Import the wezterm module
local wezterm = require 'wezterm'
-- Creates a config object which we will be adding our config to
local config = wezterm.config_builder()

--config.color_scheme = 'Tokyo Night'
config.hide_tab_bar_if_only_one_tab = true

return config
