-- -- -- -- -- Debugging -- -- -- -- --
local dap = require "dap"
local dapui = require "dap.ui.widgets"

map("n", "<leader>dc", dap.continue, opt)
map("n", "<leader>dC", dap.step_into, opt)
map("n", "<leader>db", dap.toggle_breakpoint, opt)
map("n", "<leader>do", dap.step_over, opt)
map("n", "<leader>dO", dap.step_out, opt)
map("n", "<leader>dl", dap.run_last, opt)
map("n", "<leader>dr", dap.repl.toggle, opt)
map("n", "<leader>dt", dap.terminate, opt)
map("n", "<leader>dh", dapui.hover, opt)

-- require("dap-python").setup("~/.local/share/virtualenvs/debugpy/bin/python")
