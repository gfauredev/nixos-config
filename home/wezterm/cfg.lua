local wezterm = require "wezterm"
-- General options
cfg = {
  enable_wayland = true,
  -- front_end = "Software", -- Disable hardware acceleration for nvidia GPU
  font = wezterm.font "FiraCode Nerd Font",
  font_size = 11,
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
  enable_kitty_graphics = true, -- Kitty graphics protocol
  colors = { selection_bg = "#ffddcc" },
}
