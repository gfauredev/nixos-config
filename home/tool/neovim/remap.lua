-- -- -- -- -- Native remaps -- -- -- -- --
local mapopt = { noremap = true, silent = true }
local map = vim.keymap.set
local lsp = require "lspconfig"

-- normal mode       = n
-- insert mode       = i
-- visual mode       = v
-- visual block mode = x
-- term mode         = t
-- command mode      = c
-- operator pending  = o
-- n+v+o = default   = ""

-- space as leader key
map("", "<Space>", "<Nop>", mapopt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- movement
map("", "c", "h", mapopt)
map("", "t", "j", mapopt)
map("", "s", "k", mapopt)
map("", "r", "l", mapopt)
map("n", "t", "gj", mapopt)
map("n", "s", "gk", mapopt)
-- go to current context
-- map("n", "[c", function() require("treesitter-context").go_to_context() end, mapopt)

-- MAJ move for fast move
map("", "C", "0", mapopt)
map("", "T", "<C-d>", mapopt)
map("", "S", "<C-u>", mapopt)
map("", "R", "$", mapopt)

-- words moving
map("", "é", "w", mapopt)
map("", "É", "W", mapopt)
-- till with h
map("", "h", "t", mapopt)
map("", "H", "T", mapopt)
-- find & till, forward and backward
map("", ";", ",", mapopt)
map("", ",", ";", mapopt)
-- Navigate buffers
map("n", "<a-r>", "<cmd>bnext<CR>", mapopt)
map("n", "<a-c>", "<cmd>bprevious<CR>", mapopt)

-- replace
map("", "j", "r", mapopt)
map("", "J", "R", mapopt)
map("", "l", "c", mapopt)
map("", "L", "C", mapopt)

-- go to cmd line mode easier in bépo
map("n", "’", ":", mapopt)
map("n", "'", ":", mapopt)

-- changing vim window
map("n", "w", "<C-w>", mapopt)
map("n", "W", "<C-w><C-w>", mapopt)

-- indent easier with bépo
map("", "»", ">", mapopt)
map("", "«", "<", mapopt)
map("", "<S-»>", ">>", mapopt)
map("", "<S-«>", "<<", mapopt)

-- redo
map("n", "gr", "<C-r>", mapopt)

-- paste that don’t copy what you are replacing
map("v", "p", '"_dP', mapopt)

-- Netrw
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function(args)
    map("n", "t", "j", { buffer = args.buf })
    map("n", "s", "k", { buffer = args.buf })
  end
})

-- LSP
map("n", "<leader>e", vim.diagnostic.open_float)
map("n", "ge", vim.diagnostic.goto_next)
map("n", "gE", vim.diagnostic.goto_prev)
map("n", "<leader>q", vim.diagnostic.setloclist) -- Replaced by trouble
-- Below maps after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- local mapopt = { buffer = ev.buf }
    map("n", "gR", vim.lsp.buf.references, mapopt)
    map("n", "gd", vim.lsp.buf.definition, mapopt)
    map("n", "gD", vim.lsp.buf.declaration, mapopt)
    map("n", "gt", vim.lsp.buf.type_definition, mapopt)
    map("n", "gi", vim.lsp.buf.implementation, mapopt)
    map("n", "<leader>h", vim.lsp.buf.hover, mapopt)
    map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, mapopt)
    map("n", "<leader>n", vim.lsp.buf.rename, mapopt)
    map("n", "<leader>s", vim.lsp.buf.signature_help, mapopt)
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, mapopt)
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, mapopt)
    map("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, mapopt)
  end,
})

-- Language selection for ltex-ls
vim.api.nvim_create_user_command("Ltlang", function(opt) -- FIXME
    for _, client in ipairs(vim.lsp.get_clients({ name = "ltex" })) do
      client.notify("workspace/didChangeConfiguration",
        { settings = { ltex = { language = opt.fargs[1] } } }
      )
    end
  end,
  { nargs = 1 })
