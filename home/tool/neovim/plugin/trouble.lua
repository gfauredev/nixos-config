-- Trouble, better LSP messages
local map = vim.keymap.set
local mapopt = { noremap = true, silent = true }

require "trouble".setup()
map("n", "<leader>t", "<cmd>TroubleToggle<cr>", mapopt) -- FIXME
