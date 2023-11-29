-- Autocompletion
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
