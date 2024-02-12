-- -- -- -- -- Autocommands -- -- -- -- --
local opt = vim.opt

-- Relative number only when focused in normal mode
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

-- Auto format on save
local autoFormatId = vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function() vim.lsp.buf.format() end
})

-- Add Tera HTML files as htmldjango filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.html" },
  callback = function()
    if vim.fn.search("{{.\\{-}}}") > 0 or vim.fn.search("{%.\\{-}%}") > 0 then
      vim.api.nvim_del_autocmd(autoFormatId)
    end
  end
})

-- Auto open PDF Typst
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.typ",
  callback = function()
    if vim.bo.filetype ~= "typst" then
      local file_path = vim.fn.expand('%:p')
      local pdf_file = string.gsub(file_path, "%.typ$", ".pdf")
      vim.fn.system(string.format("zathura %s & disown", pdf_file))
    end
  end
})
