-- Additional filetypes

-- Typst
vim.filetype.add({ extension = { typ = "typst" } }) -- Add typst filetype

-- Add terahtml filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.html" },
  callback = function()
    if vim.fn.search("{{.\\{-}}}") > 0 or vim.fn.search("{%.\\{-}%}") > 0 then
      vim.api.nvim_buf_set_option(0, 'filetype', 'terahtml')
    end
  end
})
