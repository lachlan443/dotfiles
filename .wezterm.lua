-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()



--config.color_scheme = 'Tokyo Night'
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Tokyo Night'
config.colors = {
   foreground = "#FFFFFF", -- white font color
}


local act = wezterm.action

config.keys = {
  -- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = act.SendKey {
      key = 'b',
      mods = 'ALT',
    },
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = act.SendKey { key = 'f', mods = 'ALT' },
  },
}


return config
