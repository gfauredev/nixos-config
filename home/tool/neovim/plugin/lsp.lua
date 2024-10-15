-- Language servers configurations
local lsp = require "lspconfig"
local util = require 'lspconfig.util'
-- Set up completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Scripting & Configuration
lsp.bashls.setup {
  capabilities = capabilities
}
lsp.nil_ls.setup {
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
lsp.ts_ls.setup {
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
      dictionary = {
        fr = { "mdr" },
      },
      additionalRules = {
        enablePickyRules = true,
        motherTongue = "fr",
      },
    },
  },
  filetypes = { "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc", "typst" },
})
lsp.marksman.setup {
  capabilities = capabilities,
}
lsp.tinymist.setup {
  capabilities = capabilities,
  offset_encoding = "utf-8",
  -- root_dir = util.find_git_ancestor,
  root_dir = function(filename, bufnr)
    return vim.fn.getcwd()
  end,
  single_file_support = true, -- TODO fix need for a .git/ to find working directory
  settings = {
    outputPath = "$dir/$name",
    exportPdf = "onDocumentHasTitle",
    rootPath = "-",
    formatterMode = "typstyle",
  }
}
-- lsp.typst_lsp.setup({ -- DEPRECATED
--   capabilities = capabilities,
--   single_file_support = true, -- TODO fix need for a .git/ to find working directory
--   settings = {
--     exportPdf = "onSave",
--   },
-- })

-- Formatting
lsp.dprint.setup {
  capabilities = capabilities,
}
