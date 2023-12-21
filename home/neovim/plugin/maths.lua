local mapopt = { noremap = true, silent = true }
local map = vim.keymap.set
local nabla = require "nabla"

-- nabla.enable_virt()

map("", "<leader>p", nabla.popup, mapopt)
