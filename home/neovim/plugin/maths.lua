local mapopt = { noremap = true, silent = true }
local map = vim.keymap.set
local nabla = require "nabla"

map("", "<leader>m", nabla.enable_virt, mapopt)
map("", "<leader>p", nabla.popup, mapopt)
