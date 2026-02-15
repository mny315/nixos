local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 1. ШРИФТ
config.font = wezterm.font("JetBrains Mono")
config.font_size = 15.0

-- 4. ИНТЕРФЕЙС И ТЕМА
config.color_scheme = "Tokyo Night"
config.enable_tab_bar = false
config.window_padding = { left = 12, right = 12, top = 12, bottom = 12 }
config.window_close_confirmation = "NeverPrompt"
config.enable_wayland = true
config.front_end = "OpenGL"
config.dpi = 192

return config
