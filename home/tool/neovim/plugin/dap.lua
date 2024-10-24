local dap = require "dap"
local dapui = require "dap.ui.widgets"

-- Debuggers --

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

-- Configs --

dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:1234',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  },
}

-- UI --

local ui = require "dapui"

ui.setup()

-- Keymaps --

local map = vim.keymap.set
local mapopt = { noremap = true, silent = true }

map("n", "<leader>du", ui.toggle, mapopt) -- Open UI
map("n", "<leader>dc", dap.continue, mapopt)
map("n", "<leader>dC", dap.step_into, mapopt)
map("n", "<leader>db", dap.toggle_breakpoint, mapopt)
map("n", "<leader>do", dap.step_over, mapopt)
map("n", "<leader>dO", dap.step_out, mapopt)
map("n", "<leader>dl", dap.run_last, mapopt)
map("n", "<leader>dr", dap.repl.toggle, mapopt)
map("n", "<leader>dt", dap.terminate, mapopt)
map("n", "<leader>dh", dapui.hover, mapopt)
