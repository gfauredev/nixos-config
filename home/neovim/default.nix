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
      ${builtins.readFile ./nvchad.lua}
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
      ##### Libraries #####
      nvchad # Full-blown, IDE like config
      lazy-nvim # Lazy loading plugins
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
      base46 # NvChad themes
      nvchad-ui # Beautiful UI
      nvterm # Nice terminal
      nvim-colorizer-lua # Manage colors
      nvim-web-devicons # Icons
      indent-blankline-nvim # Auto indentation
      gitsigns-nvim # Displays git related indications
      comment-nvim # Comment/Uncomment easily
      nvim-tree-lua # Tree file explorer
      which-key-nvim # Indications on current keys
      # tokyonight-nvim # Theme
      # dashboard-nvim # Better start screen
      # hologram-nvim # Image viewer
      # image-nvim # Image viewer
      # sniprun # Run snippets of code from neovim

      ##### Assistance & Completion #####
      nvim-lspconfig # Boilerplate to use language servers
      nvim-cmp # Autocompletion for neovim
      friendly-snippets # Snippets collection
      luasnip # Snippet engine
      nvim-autopairs # Handle pairs like parentheses
      cmp_luasnip # LuaSnip as cmp source
      cmp-nvim-lua # Use ls as cmp source
      cmp-nvim-lsp # Use ls as cmp source
      cmp-buffer # Buffer content as cmp source
      cmp-path # FS path as cmp source
      # cmp-fuzzy-buffer # Buffer content as cmp source
      # cmp-fuzzy-path # FS path as cmp source
      # cmp-cmdline # Nvim commands line mode completion source
      # cmp-git # Git commits messages as cmp source
      # cmp-nvim-lsp-signature-help
      # cmp-zsh # ZSH completions in Neovim
      # nvim-dap # Debugger protocol
      # nvim-dap-python # Use dap with debugpy
      # cmp-dap # Debugging messages as cmp source
      # none-ls-nvim # Reload
      # lsp-zero-nvim # Easier lsp config for neovim
      # trouble-nvim # Better presentation of messages

      ##### Search & Move #####
      telescope-nvim # Fuzzy search & navigate files & code
      # telescope-fzf-native-nvim # Fuzzy search & navigate
      # telescope-media-files-nvim # Works with hacky ueberzug
      # leap-nvim # Navigate efficiently in code
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
