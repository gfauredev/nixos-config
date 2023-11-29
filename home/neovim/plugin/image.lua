-- MISC

-- local null = require "null-ls"
-- null.setup({
--   sources = {
--     -- null.builtins.diagnostics.ruff,
--     null.builtins.formatting.black,
--     -- null.builtins.formatting.isort,
--     null.builtins.formatting.prettier.with({
--       filetypes = { "yaml", "toml", "markdown", "latex", "tex" },
--     }),
--   }
-- })

-- require "zk".setup({ -- Zettelkasten
--   picker = "telescope",
-- })

-- Markdown preview
-- map("n", "<leader>m", "<cmd>MarkdownPreviewToggle<CR>", opt)

-- require "hologram".setup { -- Images inside Neovim
--   auto_display = true      -- automatic markdown image display
-- }

-- require("image").setup({
--   backend = "kitty",
--   integrations = {
--     markdown = {
--       enabled = true,
--       clear_in_insert_mode = false,
--       download_remote_images = true,
--       only_render_image_at_cursor = false,
--       filetypes = { "markdown", "vimwiki" }, -- markdown extensions
--     },
--     neorg = {
--       enabled = true,
--       clear_in_insert_mode = false,
--       download_remote_images = true,
--       only_render_image_at_cursor = false,
--       filetypes = { "norg" },
--     },
--   },
--   max_width = nil,
--   max_height = nil,
--   max_width_window_percentage = nil,
--   max_height_window_percentage = 50,
--   window_overlap_clear_enabled = false, -- toggles when overlap
--   window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
-- })
