-- Language servers configurations
local lsp = require "lspconfig"
-- Set up completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Scripting & Configuration
lsp.bashls.setup {
  capabilities = capabilities
}
lsp.nil_ls.setup {
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

-- Web development
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
  filetypes = { "html", "htmldjango", "gohtmltmpl" },
  init_options = {
    provideFormatter = true
  }
})
lsp.jsonls.setup {
  capabilities = capabilities
}

-- Low level development
lsp.rust_analyzer.setup {
  capabilities = capabilities
}
lsp.arduino_language_server.setup {
  capabilities = capabilities
}
lsp.clangd.setup {
  capabilities = capabilities
}

-- Writing & Notetaking
lsp.ltex.setup({
  capabilities = capabilities,
  settings = {
    ltex = {
      language = "fr",
    },
  },
  filetypes = { "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc", "typst" },
})
lsp.marksman.setup {
  capabilities = capabilities,
}
lsp.typst_lsp.setup({
  capabilities = capabilities,
  -- cmd = { "typst-lsp" },
  -- filetypes = { "typst" },
  single_file_support = true, -- TODO fix need for a .git/ to find working directory
  settings = {
    -- exportPdf = "onType",
    exportPdf = "onSave",
    -- exportPdf = "never",
  },
})

-- Formatting
lsp.dprint.setup {
  capabilities = capabilities
}
