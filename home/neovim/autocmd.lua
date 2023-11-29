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
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function() vim.lsp.buf.format() end
})
