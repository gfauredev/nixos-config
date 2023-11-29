-- -- -- -- -- Remaps -- -- -- -- --
-- normal mode       = n
-- insert mode       = i
-- visual mode       = v
-- visual block mode = x
-- term mode         = t
-- command mode      = c
-- operator pending  = o
-- n+v+o = default   = ""

-- space as leader key
map("", "<Space>", "<Nop>", opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- movement
map("", "c", "h", opt)
map("", "t", "j", opt)
map("", "s", "k", opt)
map("", "r", "l", opt)
map("n", "t", "gj", opt)
map("n", "s", "gk", opt)
-- go to current context
map("n", "[c", function() require("treesitter-context").go_to_context() end, opt)

-- MAJ move for fast move
map("", "C", "0", opt)
map("", "T", "<C-d>", opt)
map("", "S", "<C-u>", opt)
map("", "R", "$", opt)

-- words moving
map("", "é", "w", opt)
map("", "É", "W", opt)
-- till with h
map("", "h", "t", opt)
map("", "H", "T", opt)
-- find & till, forward and backward
map("", ";", ",", opt)
map("", ",", ";", opt)
-- Navigate buffers
map("n", "<a-r>", "<cmd>bnext<CR>", opt)
map("n", "<a-c>", "<cmd>bprevious<CR>", opt)

-- replace
map("", "j", "r", opt)
map("", "J", "R", opt)
map("", "l", "c", opt)
map("", "L", "C", opt)

-- go to cmd line mode easier in bépo
map("n", "’", ":", opt)
map("n", "'", ":", opt)

-- changing vim window
map("n", "w", "<C-w>", opt)
map("n", "W", "<C-w><C-w>", opt)

-- indent easier with bépo
map("", "»", ">", opt)
map("", "«", "<", opt)
map("", "<S-»>", ">>", opt)
map("", "<S-«>", "<<", opt)

-- redo
map("n", "gr", "<C-r>", opt)

-- paste that don’t copy what you are replacing
map("v", "p", '"_dP', opt)

-- Netrw
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function(args)
    map("n", "t", "j", { buffer = args.buf })
    map("n", "s", "k", { buffer = args.buf })
  end
})

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

-- LSP
map("n", "<leader>e", vim.diagnostic.open_float)
map("n", "ge", vim.diagnostic.goto_next)
map("n", "gE", vim.diagnostic.goto_prev)
-- map("n", "<leader>q", vim.diagnostic.setloclist) -- Replaced by trouble
-- map after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- local opt = { buffer = ev.buf }
    map("n", "gR", vim.lsp.buf.references, opt)
    map("n", "gd", vim.lsp.buf.definition, opt)
    map("n", "gD", vim.lsp.buf.declaration, opt)
    map("n", "gt", vim.lsp.buf.type_definition, opt)
    map("n", "gi", vim.lsp.buf.implementation, opt)
    map("n", "<leader>h", vim.lsp.buf.hover, opt)
    map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opt)
    map("n", "<leader>n", vim.lsp.buf.rename, opt)
    map("n", "<leader>s", vim.lsp.buf.signature_help, opt)
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opt)
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opt)
    map("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opt)
  end,
})
