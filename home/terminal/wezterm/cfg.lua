cfg = {
  enable_wayland = false,
  front_end = "WebGpu", -- Disable hardware acceleration
  font = wezterm.font "FiraCode Nerd Font",
  font_size = 14,
  enable_tab_bar = false,
  audible_bell = "Disabled",
  -- window_background_opacity = 0.8,
  window_close_confirmation = "NeverPrompt",
  scrollback_lines = 5000,
  window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2,
  },
  default_prog = { "$SHELL" }
  -- enable_kitty_graphics = true, -- Kitty graphics protocol
  -- colors = { selection_bg = "#ffddcc" },
}
