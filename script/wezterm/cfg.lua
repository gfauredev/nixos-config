local wezterm = require "wezterm"
-- General options
cfg = {
  enable_wayland = true,
  font = wezterm.font "FiraCode Nerd Font",
  enable_tab_bar = false,
  window_background_opacity = 0.8,
  window_close_confirmation = "NeverPrompt",
  scrollback_lines = 5000,
  window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2,
  },
}
