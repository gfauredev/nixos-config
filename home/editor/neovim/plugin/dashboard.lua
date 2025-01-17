require "dashboard".setup {  -- Dashboard
  theme = "hyper",           --  theme is doom and hyper default is hyper
  disable_move = false,      --  default is false disable move keymap for hyper
  shortcut_type = "letter",  --  shorcut type 'letter' or 'number'
  change_to_vcs_root = true, -- default is false,for open file in hyper mru. it will change to the root of vcs
  config = {
    week_header = {
      enable = true,
    },
    shortcut = {
      { desc = "Feels like we’re gonna edit some text" },
      {
        icon = "󰱼 ",
        desc = "",
        action = "Telescope find_files",
        key = "f",
      },
      {
        icon = "󱎸 ",
        desc = "",
        action = "Telescope live_grep",
        key = "g",
      },
    },
    footer = {},
  },                   --  config used for theme
  hide = {
    statusline = true, -- hide statusline default is true
    tabline = true,    -- hide the tabline
    winbar = true,     -- hide winbar
  },
}
