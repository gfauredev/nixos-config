local opt = { noremap = true, silent = true }
local map = vim.keymap.set

require "orgmode".setup_ts_grammar()      -- Org mode grammars

require "nvim-treesitter.configs".setup { -- Treesitter
  highlight = {
    enable = true,
    -- disable = { "html" },
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

-- local null = require "null-ls"
-- null.setup({
--   sources = {
--     -- null.builtins.diagnostics.ruff,
--     null.builtins.formatting.black,
--     -- null.builtins.formatting.isort,
--     null.builtins.formatting.prettier.with({
--       filetypes = { "yaml", "toml", "markdown", "latex", "tex" },
--     }),
--   }
-- })

require "Comment".setup() -- Comment easily

require 'treesitter-context'.setup {
  enable = true,
  max_lines = 0,            -- How many lines the window should span, <= 0 no limit
  min_window_height = 0,    -- Minimum editor window height to enable context
  line_numbers = true,
  multiline_threshold = 20, -- Maxi nb of lines to collapse for a single context line
}

-- Telescope (fuzzy finder)
require "telescope".setup {
  defaults = {
    layout_strategy = "vertical",
    layout_config = { width = .95, height = .95 },
  }
}
local telescope = require "telescope.builtin"
map("n", "<leader>ff", telescope.find_files, {})
map("n", "<leader>fg", telescope.live_grep, {})
map("n", "<leader>fb", telescope.buffers, {})
map("n", "<leader>fh", telescope.help_tags, {})
map("n", "<leader>fx", telescope.quickfix, {})

-- Trouble, better LSP messages
require "trouble".setup()
map("n", "<leader>l", "<cmd>TroubleToggle<cr>", opt)

-- Leap, better moving
map("n", "k", "<Plug>(leap-forward-to)", opt)
map("n", "K", "<Plug>(leap-backward-to)", opt)

require "gitsigns".setup()   -- Gitsigns

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

-- Org mode
require "orgmode".setup({
  org_agenda_files = { "~/note/*.org" }, -- ISO date
  org_default_notes_file = "~/note/in.org",
  mappings = {
    -- disable_all = true,
    global = {
      org_agenda = { '<Leader>oa' },
      org_capture = { '<Leader>oc' },
    },
    org = {
      org_cycle = { '<TAB>' },
      org_change_date = { '<Leader>ocid' },
      org_priority_up = { '<Leader>ociR' },
      org_priority_down = { '<Leader>ocir' },
      org_todo = { '<Leader>ocit' },
      org_todo_prev = { '<Leader>ociT' },
    }
  }
})

-- Neorg
-- require "neorg".setup {
--   load = {
--     ["core.defaults"] = {},
--   }
-- }

-- require "zk".setup({ -- Zettelkasten
--   picker = "telescope",
-- })

-- Markdown preview
map("n", "<leader>m", "<cmd>MarkdownPreviewToggle<CR>", opt)

-- Debuggers
local dap = require "dap"
local dapui = require "dap.ui.widgets"
map("n", "<leader>c", dap.continue, opt)
map("n", "<leader>C", dap.step_into, opt)
map("n", "<leader>b", dap.toggle_breakpoint, opt)
map("n", "<leader>o", dap.step_over, opt)
map("n", "<leader>O", dap.step_out, opt)
map("n", "<leader>dl", dap.run_last, opt)
map("n", "<leader>dr", dap.repl.toggle, opt)
map("n", "<leader>dt", dap.terminate, opt)

map("n", "<leader>dh", dapui.hover, opt)

require("dap-python").setup("~/.local/share/virtualenvs/debugpy/bin/python")

-- require "hologram".setup { -- Images inside Neovim
--   auto_display = true      -- automatic markdown image display
-- }

require("image").setup({
  backend = "kitty",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "markdown", "vimwiki" }, -- markdown extensions
    },
    neorg = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "norg" },
    },
  },
  max_width = nil,
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 50,
  window_overlap_clear_enabled = false, -- toggles when overlap
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
})
