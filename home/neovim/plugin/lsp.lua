-- -- -- -- -- Language servers -- -- -- -- --
local lsp = require "lspconfig"
-- Set up completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Script
lsp.bashls.setup {
  capabilities = capabilities
}
lsp.rnix.setup {
  capabilities = capabilities
}
lsp.lua_ls.setup {
  capabilities = capabilities
}
lsp.pyright.setup {
  capabilities = capabilities
}
lsp.ruff_lsp.setup {
  capabilities = capabilities
}

-- Web
lsp.tsserver.setup {
  capabilities = capabilities
}
lsp.eslint.setup {
  capabilities = capabilities
}
lsp.cssls.setup {
  capabilities = capabilities
}
lsp.html.setup({
  capabilities = capabilities,
  filetypes = { "html", "gohtmltmpl", "htmldjango" },
  init_options = {
    provideFormatter = false
  }
})
lsp.jsonls.setup {
  capabilities = capabilities
}
-- lsp.intelephense.setup{}

-- Low level
lsp.rust_analyzer.setup {
  capabilities = capabilities
}
lsp.arduino_language_server.setup {
  capabilities = capabilities
}
lsp.clangd.setup {
  capabilities = capabilities
}
-- lsp.ccls.setup{
--   capabilities = capabilities
-- }

-- Misc
lsp.typst_lsp.setup({
  capabilities = capabilities,
  settings = {
    -- exportPdf = "onType",
    -- exportPdf = "onSave",
    exportPdf = "never",
  },
})
lsp.ltex.setup({
  capabilities = capabilities,
  settings = {
    ltex = {
      language = "fr",
    },
  },
  filetypes = { "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc", "typst" },
})
-- lsp.sqlls.setup{}
-- lsp.sqls.setup{}
-- lsp.marksman.setup{}
