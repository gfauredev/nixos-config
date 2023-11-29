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
