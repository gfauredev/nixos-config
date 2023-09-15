local opt = vim.opt

-- Files & OS
opt.backup = false            -- creates a backup file
opt.swapfile = true           -- creates swapfile
opt.clipboard = "unnamedplus" -- neovim defaults to the system clipboard
opt.fileencoding = "utf-8"    -- the encoding written to a file
opt.undofile = true           -- enable persistent undo
opt.writebackup = false       -- forbid edditing if currently edited file

-- Interface
opt.cmdheight = 1         -- space in the neovim command line
opt.pumheight = 10        -- pop up menu height
opt.showtabline = 0       -- never show tabs
opt.termguicolors = true  -- set term gui colors
opt.cursorline = true     -- highlight the current line
opt.number = true         -- set numbered lines
opt.relativenumber = true -- set relatively numbered lines
opt.signcolumn = "yes"    -- always show the sign column
opt.wrap = true           -- soft break if line goes outside the screen
opt.scrolloff = 8         -- Keep 8 lines above & below cursor
opt.sidescrolloff = 8     -- Keep 8 columns at the right & left of the cursor
opt.mouse = ""            -- disable mouse in neovim

-- Text & Commands
opt.hlsearch = false   -- highlight all matches on previous search pattern
opt.incsearch = true   -- highlight matches on search pattern being typed
opt.ignorecase = true  -- ignore case in search patterns
opt.smartcase = true   -- smart case
opt.smartindent = true -- make indenting smarter again
opt.updatetime = 300   -- faster completion (4000ms default)
opt.expandtab = true   -- convert tabs to spaces
opt.shiftwidth = 2     -- number of spaces for each indentation
opt.tabstop = 2        -- insert 2 spaces for a tab

-- Netrw file manager
vim.g.netrw_banner = 0    -- disable anoying Netrw banner
vim.g.netrw_liststyle = 3 -- treeview
-- vim.g.netrw_altv = 1          -- open splits to the right
-- vim.g.netrw_browser_split = 4 -- open in a prior window

-- Filetypes
vim.filetype.add({ extension = { typ = "typst" } }) -- Add typst filetype
-- Add gohtmltmpl filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.html" },
  callback = function()
    if vim.fn.search("{{.\\{-}}}") ~= 0 and vim.fn.search("{%.\\{-}%}") == 0 then
      vim.api.nvim_buf_set_option(0, 'filetype', 'gohtmltmpl')
    end
  end
})

-- Relative number or not
vim.api.nvim_create_autocmd({ "FocusLost", "InsertEnter" }, {
  callback = function() opt.relativenumber = false end
})
vim.api.nvim_create_autocmd({ "FocusGained", "InsertLeave" }, {
  callback = function()
    if vim.bo.filetype ~= "dashboard" then
      opt.relativenumber = true
    end
  end
})

-- Deprecated
-- opt.completeopt = { "menu", "menuone", "noselect" }
-- opt.conceallevel = 0    -- so that `` is visible in markdown files
-- opt.splitbelow = true  -- force horizontal splits to go below current window
-- opt.splitright = true  -- force vertical splits to go to the right
-- opt.timeoutlen = 1000     -- milisecs to wait for a mapped sequence to complete
-- opt.laststatus = 3
-- opt.showcmd = false
-- opt.ruler = false
-- opt.numberwidth = 3    -- set number column width
-- opt.shortmess:append "c"
-- opt.whichwrap:append("<,>,[,],h,l")
-- opt.iskeyword:append("-")
-- opt.fillchars.eob = " "
-- opt.guifont = "monospace:h17" -- font used in graphical neovim applications
-- opt.foldmethod = "expr"                     -- Treesitter folding
-- opt.foldexpr = "nvim_treesitter#foldexpr()" -- Treesitter folding
