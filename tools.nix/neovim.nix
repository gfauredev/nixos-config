{ pkgs, config, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = ''
      require("tokyonight").setup({
        style = "storm",
        transparent = true
      })
      vim.cmd [[colorscheme tokyonight]]

      require "opt" -- (Neo)Vim options
      require "key" -- Custom remaps
      require "lsp" -- LSP Zero, completion
      require "set" -- Plugins setups
      require "dap" -- Debugging
    '';
    # require "cmp" -- Autocompletion
    # require "lsp" -- Language servers
    plugins = with pkgs.vimPlugins; [
      # Libraries
      plenary-nvim
      fuzzy-nvim

      # Treesitter (parsing), Colorscheme (theme), Highlighting
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-treesitter-context
      tokyonight-nvim
      nvim-web-devicons

      # Assistance & Completion
      nvim-lspconfig # Boilerplate to use language servers
      cmp-nvim-lsp # Use ls as cmp source
      # cmp-buffer # Buffer content as cmp source
      cmp-fuzzy-buffer # Buffer content as cmp source
      # cmp-path # FS path as cmp source
      cmp-fuzzy-path # FS path as cmp source
      cmp-cmdline # Nvim commands line mode completion source
      cmp-git # Git commits messages as cmp source
      cmp-nvim-lsp-signature-help
      cmp-zsh # ZSH completions in Neovim
      nvim-dap # Debugger protocol
      cmp-dap # Debugging messages as cmp source
      luasnip # Snippet engine
      cmp_luasnip # LuaSnip as cmp source
      friendly-snippets # Snippets collection
      null-ls-nvim # Use non-lsp code tools as ls within Neovim
      nvim-cmp # Autocompletion for neovim
      lsp-zero-nvim # Easier lsp config for neovim
      trouble-nvim # Better presentation of messages
      cmp-tabnine # AI code completion
      # nvim-jdtls # Java (Eclipse)
      # go-nvim # Go
      # vim-go # Go (Vimscript)

      # Quality of life & Search
      telescope-nvim # Fuzzy search & navigate files & code
      telescope-fzf-native-nvim # Fuzzy search & navigate
      comment-nvim # Comment/Uncomment easily
      gitsigns-nvim # Displays git related indications
      leap-nvim # Navigate efficiently in code
      which-key-nvim # Indications on current keys
      sniprun # Run snippets of code from neovim
      neorg # New oganization specific lightweight markup
      orgmode # Organization specific lightweight markup
      markdown-preview-nvim # Markdown previewing
      hologram-nvim # Image viewer
      dashboard-nvim # Better start screen
      # zk-nvim # zk integration
      # hop-nvim # Navigate efficiently in code
      # grammar-guard-nvim
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };
}
