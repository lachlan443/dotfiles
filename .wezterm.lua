-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

--config.font_size = 12.0
config.font = wezterm.font('JetBrains Mono')
--config.font_size = 12.0

config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Catppuccin Mocha'
-- config.colors = {
--    foreground = "#FFFFFF", -- white font color
-- }
local act = wezterm.action

config.keys = {
  {
    key = 'Enter',
    mods = 'OPT',
    action = act.SendKey { key = 'Enter', mods = 'SHIFT'  }, -- send a normal newline
  },
}

return config
