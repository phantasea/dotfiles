local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'JetBrains Mono'
config.font_size = 18
config.color_scheme = 'Batman'
config.tab_bar_at_bottom = false
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

return config
