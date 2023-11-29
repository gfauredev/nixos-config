-- -- -- -- -- Debugging -- -- -- -- --
local map = vim.keymap.set
local mapopt = { noremap = true, silent = true }
local dap = require "dap"
local dapui = require "dap.ui.widgets"

map("n", "<leader>dc", dap.continue, mapopt)
map("n", "<leader>dC", dap.step_into, mapopt)
map("n", "<leader>db", dap.toggle_breakpoint, mapopt)
map("n", "<leader>do", dap.step_over, mapopt)
map("n", "<leader>dO", dap.step_out, mapopt)
map("n", "<leader>dl", dap.run_last, mapopt)
map("n", "<leader>dr", dap.repl.toggle, mapopt)
map("n", "<leader>dt", dap.terminate, mapopt)
map("n", "<leader>dh", dapui.hover, mapopt)

-- require("dap-python").setup("~/.local/share/virtualenvs/debugpy/bin/python")
