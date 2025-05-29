local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 12

config.enable_tab_bar = false

config.color_scheme = "rose-pine-moon"

config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 800

return config
