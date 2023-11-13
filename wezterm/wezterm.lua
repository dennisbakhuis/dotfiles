-- ----------------------------------------
-- WezTerm Configuration
--
-- Author: Dennis Bakhuis
-- ----------------------------------------

local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ----------------------------------------
-- Main
-- ----------------------------------------

-- Set Colorscheme to tokyonight but match bgcolor with nightfly from neovim
local tokyonight = wezterm.color.get_builtin_schemes()['tokyonight_moon']
tokyonight.background = '#001728'
config.colors = tokyonight

config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 1.0
config.native_macos_fullscreen_mode = true

config.font = wezterm.font "FiraCode Nerd Font Mono"
config.font_size = 14.0

config.initial_rows = 40
config.initial_cols = 100
config.window_padding = {
  left = '4px',
  right = '2px',
  top = '8px',
  bottom = 0,
}
config.window_frame = {
  border_left_width = 0,
  border_right_width = 0,
  border_bottom_height = 0,
  border_top_height = 0,
}
config.enable_scroll_bar = false
config.use_resize_increments = true
config.adjust_window_size_when_changing_font_size = false

-- Default full screen is set to option + enter
-- config.keys = {
--   {
--     key = 'f',
--     mods = 'CMD|SHIFT',
--     action = wezterm.action.ToggleFullScreen,
--   },
-- }

-- ----------------------------------------
-- Done
-- ----------------------------------------

return config

