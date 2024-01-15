local mapopt = { noremap = true, silent = true }
local map = vim.keymap.set
local nabla = require "nabla"

local function toggle_virt()
  nabla.toggle_virt({ autogen = true })
end

map("", "<leader>m", toggle_virt, mapopt)
-- map("", "<leader>m", nabla.enable_virt, mapopt)
-- map("", "<leader>p", nabla.popup, mapopt)
