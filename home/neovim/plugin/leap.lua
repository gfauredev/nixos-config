-- Leap, better moving
local map = vim.keymap.set
local mapopt = { noremap = true, silent = true }

map("n", "k", "<Plug>(leap-forward-to)", mapopt)
map("n", "K", "<Plug>(leap-backward-to)", mapopt)
