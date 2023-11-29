{ inputs, lib, config, pkgs, ... }: {
  # nixpkgs.overlays = [
  #   inputs.neovim-nightly-overlay.overlays.default
  # ];

  programs.neovim = {
    enable = true;
    # package = pkgs.neovim-nightly;
    defaultEditor = true;
    extraLuaConfig = ''
      ${builtins.readFile ./key.native.lua}
    '';
    #     require("tokyonight").setup({
    #       style = "storm",
    #       transparent = true
    #     })
    #     vim.cmd [[colorscheme tokyonight]]
    #   '';
    #   ${builtins.readFile ./opt.lua}
    #   ${builtins.readFile ./key.plugins.lua}
    #   ${builtins.readFile ./lsp.lua}
    #   ${builtins.readFile ./dap.lua}
    #   ${builtins.readFile ./set.lua}
    # '';
    plugins = with pkgs.vimPlugins; [
      nvchad # Full-blown, IDE like config
      # nvchad-ui # Full-blown ui

      ##### Libraries #####
      nvim-treesitter.withAllGrammars # Parsing & text highlighting
      nvim-treesitter-parsers.markdown # Parsing & text highlighting
      nvim-treesitter-parsers.norg # Parsing & text highlighting
      nvim-treesitter-textobjects # Parsing & text highlighting
      nvim-treesitter-context # Parsing & text highlighting
      # plenary-nvim
      # fuzzy-nvim
      nvim-web-devicons # Icons
      # tokyonight-nvim # Theme

      ##### Assistance & Completion & Misc #####
      # nvim-lspconfig # Boilerplate to use language servers
      # cmp-nvim-lsp # Use ls as cmp source
      # cmp-buffer # Buffer content as cmp source
      # cmp-fuzzy-buffer # Buffer content as cmp source
      # cmp-path # FS path as cmp source
      # cmp-fuzzy-path # FS path as cmp source
      # cmp-cmdline # Nvim commands line mode completion source
      # cmp-git # Git commits messages as cmp source
      # cmp-nvim-lsp-signature-help
      # cmp-zsh # ZSH completions in Neovim
      # nvim-dap # Debugger protocol
      # nvim-dap-python # Use dap with debugpy
      # cmp-dap # Debugging messages as cmp source
      # luasnip # Snippet engine
      # cmp_luasnip # LuaSnip as cmp source
      # friendly-snippets # Snippets collection
      # none-ls-nvim # Reload
      # nvim-cmp # Autocompletion for neovim
      # lsp-zero-nvim # Easier lsp config for neovim
      # trouble-nvim # Better presentation of messages
      # cmp-tabnine # AI code completion
      # nvim-jdtls # Java (Eclipse)
      # go-nvim # Go
      # vim-go # Go (Vimscript)
      # typst-vim # Typst

      ##### Quality of life & Search #####
      # telescope-nvim # Fuzzy search & navigate files & code
      # telescope-fzf-native-nvim # Fuzzy search & navigate
      # telescope-media-files-nvim # Works with hacky ueberzug
      # comment-nvim # Comment/Uncomment easily
      # gitsigns-nvim # Displays git related indications
      # leap-nvim # Navigate efficiently in code
      # which-key-nvim # Indications on current keys
      # sniprun # Run snippets of code from neovim
      neorg # New oganization specific lightweight markup
      orgmode # Organization specific lightweight markup
      # markdown-preview-nvim # Markdown previewing
      # hologram-nvim # Image viewer
      # image-nvim # Image viewer
      # dashboard-nvim # Better start screen
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
    extraLuaPackages = ps: [ ps.magick ];
    # extraPackages = with pkgs; [
    #   luajitPackages.magick
    # ];
  };
}
