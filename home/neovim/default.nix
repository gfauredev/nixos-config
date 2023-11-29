{ inputs, lib, config, pkgs, ... }: {
  # nixpkgs.overlays = [
  #   inputs.neovim-nightly-overlay.overlays.default
  # ];

  programs.neovim = {
    enable = true;
    # package = pkgs.neovim-nightly;
    defaultEditor = true;
    extraLuaConfig = ''
      ${builtins.readFile ./remap.lua}
      ${builtins.readFile ./opt.lua}
      ${builtins.readFile ./autocmd.lua}
      ${builtins.readFile ./filetype.lua}
      ${builtins.readFile ./theme.lua}
      ${builtins.readFile ./plugin/telescope.lua}
      ${builtins.readFile ./plugin/comment.lua}
      ${builtins.readFile ./plugin/neorg.lua}
      ${builtins.readFile ./plugin/orgmode.lua}
      ${builtins.readFile ./plugin/treesitter.lua}
      ${builtins.readFile ./plugin/gitsigns.lua}
      ${builtins.readFile ./plugin/lsp.lua}
      ${builtins.readFile ./plugin/cmp.lua}
      ${builtins.readFile ./plugin/dap.lua}
      ${builtins.readFile ./plugin/gdb.lua}
      ${builtins.readFile ./plugin/leap.lua}
      ${builtins.readFile ./plugin/trouble.lua}
      ${builtins.readFile ./plugin/dashboard.lua}
    '';
    plugins = with pkgs.vimPlugins; [
      ##### Libraries #####
      plenary-nvim # Library
      # fuzzy-nvim # Library

      ##### Parsing #####
      nvim-treesitter.withAllGrammars # Parsing & text highlighting
      nvim-treesitter-parsers.markdown # Parsing & text highlighting
      nvim-treesitter-parsers.norg # Parsing & text highlighting
      nvim-treesitter-textobjects # Parsing & text highlighting
      nvim-treesitter-textsubjects # Parsing & text highlighting
      nvim-treesitter-refactor # Parsing & text highlighting
      nvim-treesitter-context # Parsing & text highlighting

      ##### UI & Misc #####
      nvim-web-devicons # Icons
      gitsigns-nvim # Displays git related indications
      comment-nvim # Comment/Uncomment easily
      nvim-tree-lua # Tree file explorer
      gruvbox-nvim # Old fashioned theme
      dashboard-nvim # Better start screen
      # indent-blankline-nvim # Auto indentation TODO
      # tokyonight-nvim # Blue-ish theme
      # which-key-nvim # Indications on current keys and shortcuts TODO
      # hologram-nvim # Image viewer
      # image-nvim # Image viewer
      # sniprun # Run snippets of code from neovim

      ##### Assistance & Completion #####
      nvim-lspconfig # Boilerplate to use language servers
      nvim-cmp # Autocompletion for neovim
      friendly-snippets # Snippets collection TODO
      luasnip # Snippet engine TODO
      nvim-autopairs # Handle pairs like parentheses TODO
      cmp_luasnip # LuaSnip as cmp source TODO
      cmp-nvim-lua # Use ls as cmp source
      cmp-nvim-lsp # Use ls as cmp source
      cmp-buffer # Buffer content as cmp source
      cmp-path # FS path as cmp source
      nvim-dap # Debugger protocol
      cmp-git # Git commits messages as cmp source
      trouble-nvim # Better presentation of messages
      # cmp-fuzzy-buffer # Buffer content as cmp source
      # cmp-fuzzy-path # FS path as cmp source
      # cmp-cmdline # Nvim commands line mode completion source
      # cmp-nvim-lsp-signature-help
      # cmp-zsh # ZSH completions in Neovim
      # nvim-dap-python # Use dap with debugpy
      # cmp-dap # Debugging messages as cmp source
      # none-ls-nvim # Reload of a deprecated plugin
      # lsp-zero-nvim # Easier lsp config for neovim

      ##### Search & Move #####
      telescope-nvim # Fuzzy search & navigate files & code
      leap-nvim # Navigate efficiently in code
      # telescope-fzf-native-nvim # Fuzzy search & navigate
      # telescope-media-files-nvim # Works with hacky ueberzug
      # hop-nvim # Navigate efficiently in code

      ##### Techno & Language Specifics #####
      neorg # New oganization specific lightweight markup
      orgmode # Organization specific lightweight markup
      # cmp-tabnine # AI code completion
      # nvim-jdtls # Java (Eclipse)
      # go-nvim # Go
      # vim-go # Go (Vimscript)
      # typst-vim # Typst
      # grammar-guard-nvim
      # zk-nvim # zk integration
      # markdown-preview-nvim # Markdown previewing
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
