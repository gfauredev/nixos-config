local wezterm = require "wezterm"
local act = wezterm.action
-- Global keymaps
cfg.keys = {
  {
    key = "/",
    mods = "CTRL",
    action = act.Search { Regex = "" },
  },
  {
    key = " ",
    mods = "CTRL",
    action = act.ActivateCopyMode
  }
}
-- Mode keymaps
local key_tables = wezterm.gui.default_key_tables()
table.insert(key_tables.copy_mode,
  {
    key = "c",
    mods = "NONE",
    action = act.CopyMode "MoveLeft",
  })
table.insert(key_tables.copy_mode,
  {
    key = "t",
    mods = "NONE",
    action = act.CopyMode "MoveDown",
  })
table.insert(key_tables.copy_mode,
  {
    key = "s",
    mods = "NONE",
    action = act.CopyMode "MoveUp",
  })
table.insert(key_tables.copy_mode,
  {
    key = "r",
    mods = "NONE",
    action = act.CopyMode "MoveRight",
  })
cfg.key_tables = key_tables
