-- Additional filetypes
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
