-- -- -- -- -- Language servers -- -- -- -- --
local lsp = require "lsp-zero".preset("recommended")

lsp.setup_servers({
  -- Script
  "bashls",
  "rnix",
  "lua_ls",
  "pyright",
  "ruff_lsp",
  -- Web
  "tsserver",
  "eslint",
  "cssls",
  -- "html",
  "jsonls",
  -- "intelephense",
  -- Low level
  "rust_analyzer",
  "arduino_language_server",
  "clangd",
  -- "ccls",
  -- Misc
  -- "typst_lsp",
  -- "ltex",
  -- "sqlls",
  -- "sqls",
  -- "marksman",
})

lsp.setup({
  sources = {
    { name = "nvim_lsp",               keyword_length = 2 },
    { name = "luasnip",                keyword_length = 2 },
    { name = "fuzzy_path",             keyword_length = 2 },
    { name = "fuzzy_buffer",           keyword_length = 3 },
    { name = "nvim_lsp_signature_help" },
    -- { name = "cmp_git",                keyword_length = 2 },
    -- { name = "cmp_tabnine" },
    -- { name = "orgmode" },
    -- { name = "zsh" },
  }
})

local conf = require "lspconfig"

conf.html.setup({
  filetypes = { "html", "gohtmltmpl", "htmldjango" },
  init_options = {
    provideFormatter = false
  }
})

conf.typst_lsp.setup({
  settings = {
    -- exportPdf = "onType",
    -- exportPdf = "onSave",
    exportPdf = "never",
  },
})

conf.ltex.setup({
  settings = {
    ltex = {
      language = "fr",
    },
  },
  filetypes = { "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc", "typst" },
})

local cmp = require "cmp"

cmp.setup({
  mapping = {
    ["<C-s>"] = cmp.mapping.scroll_docs(-4),
    ["<C-t>"] = cmp.mapping.scroll_docs(4),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "fuzzy_buffer" },
  }
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "fuzzy_path" },
    { name = "cmdline" },
  })
})

-- Load snippets from friendly snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Auto format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function() vim.lsp.buf.format() end
})
