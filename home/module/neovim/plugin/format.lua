local conform = require "conform"

conform.setup({
  formatters_by_ft = {
    -- Use a sub-list to run only the first available formatter, a list to run sequentially
    markdown = { "dprint" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})
