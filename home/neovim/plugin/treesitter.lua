-- Treesitter
require "nvim-treesitter.configs".setup { -- Treesitter
  highlight = {
    enable = true,
    disable = { "nix" }, -- Too ressource intensive
    -- additional_vim_regex_highlighting = { "org" },
  },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true,
  },
}

require 'treesitter-context'.setup {
  enable = true,
  max_lines = 0,            -- How many lines the window should span, <= 0 no limit
  min_window_height = 0,    -- Minimum editor window height to enable context
  line_numbers = true,
  multiline_threshold = 20, -- Maxi nb of lines to collapse for a single context line
}
