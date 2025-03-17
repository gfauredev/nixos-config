-- Relative number only when focused in normal mode
vim.api.nvim_create_autocmd({ "FocusLost", "InsertEnter" }, {
  callback = function() vim.opt.relativenumber = false end
})
vim.api.nvim_create_autocmd({ "FocusGained", "InsertLeave" }, {
  callback = function()
    if vim.bo.filetype ~= "dashboard" then
      vim.opt.relativenumber = true
    end
  end
})

-- Auto format on save
local autoFormatId = vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function(args)
    pcall(vim.lsp.buf.format)
    pcall(require("conform").format, { bufnr = args.buf })
  end
})
-- … but not if on a Tera file (the generic HTML formatter messes these up)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  buffer = 0,
  callback = function()
    if vim.fn.search("{{.*}}") > 0 or vim.fn.search("{%.*%}") > 0 then
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

-- Disable highlighting from jdtls, worse than ts one
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client ~= nil and client.name == "jdtls" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})
