-- -- -- -- -- Plugins remaps -- -- -- -- --
-- Telescope
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
