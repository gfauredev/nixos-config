{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    # package = pkgs.neovim-nightly;
    defaultEditor = false;
    # Generate a big init file with every module, may be done cleaner
    extraLuaConfig = ''
      ${builtins.readFile ./remap.lua}
      ${builtins.readFile ./opt.lua}
    '';
    # ${builtins.readFile ./filetype.lua}
    # ${builtins.readFile ./autocmd.lua}
    # ${builtins.readFile ./theme.lua}
    # ${builtins.readFile ./plugin/telescope.lua}
    # ${builtins.readFile ./plugin/comment.lua}
    # ${builtins.readFile ./plugin/treesitter.lua}
    # ${builtins.readFile ./plugin/gitsigns.lua}
    # ${builtins.readFile ./plugin/lsp.lua}
    # ${builtins.readFile ./plugin/cmp.lua}
    # ${builtins.readFile ./plugin/leap.lua}
    # ${builtins.readFile ./plugin/trouble.lua}
    # ${builtins.readFile ./plugin/autopair.lua}
    # ${builtins.readFile ./plugin/indentline.lua}
    # ${builtins.readFile ./plugin/format.lua}
    # ${builtins.readFile ./plugin/copilot.lua}
    # ${builtins.readFile ./plugin/maths.lua}
    # ${builtins.readFile ./plugin/dap.lua}
    # ${builtins.readFile ./plugin/lint.lua}
    # ${builtins.readFile ./plugin/quarto.lua}
    # ${builtins.readFile ./plugin/notify.lua}
    # ${builtins.readFile ./plugin/image.lua}
    # ${builtins.readFile ./plugin/dashboard.lua}
    # extraLuaPackages = ps: [ ps.magick ];
    plugins = with pkgs.vimPlugins; [
      ##### Libraries #####
      # plenary-nvim # Library
      # fuzzy-nvim # Library
      # nvim-nio # Async I/O

      ##### Parsing #####
      nvim-treesitter.withAllGrammars # Parsing & text highlighting
      # nvim-treesitter-parsers.markdown # Parsing & text highlighting
      # nvim-treesitter-parsers.norg # Parsing & text highlighting
      # nvim-treesitter-parsers.arduino # Parsing & text highlighting
      # nvim-treesitter-textobjects # Parsing & text highlighting
      # nvim-treesitter-textsubjects # Parsing & text highlighting
      # nvim-treesitter-refactor # Parsing & text highlighting
      # nvim-treesitter-context # Typically displays the function signature you’re in

      ##### UI & Misc #####
      # nvim-web-devicons # Icons
      # gitsigns-nvim # Displays git related indications
      # comment-nvim # Comment/Uncomment easily
      # nvim-tree-lua # Tree file explorer
      # sniprun # Run snippets of code from neovim
      # otter-nvim # LSP & features for embedded languages
      # indent-blankline-nvim # Indentation lines
      # tokyonight-nvim # Blue-ish theme
      # gruvbox-nvim # Old fashioned, red-ish theme
      # nvim-ufo # Modern and performance fold # TODO set up
      # headlines-nvim # Highlights for titles, code blocks …
      # nvim-notify # Notifications
      # vim-table-mode # Display tables
      # image-nvim # Image viewer
      # which-key-nvim # Indications on current keys and shortcuts TODO
      # hologram-nvim # Image viewer
      # catppuccin-nvim # Pastel themes
      # dashboard-nvim # Better start screen

      ##### Assistance & Completion #####
      nvim-lspconfig # Boilerplate to use language servers
      # nvim-cmp # Autocompletion for neovim
      # cmp_luasnip # LuaSnip as cmp source
      # cmp-nvim-lua # Use ls as cmp source
      # cmp-nvim-lsp # Use ls as cmp source
      # cmp-buffer # Buffer content as cmp source
      # cmp-path # FS path as cmp source
      # friendly-snippets # Snippets collection
      # luasnip # Snippet engine
      # nvim-autopairs # Handle pairs like parentheses
      # nvim-dap # Debugger protocol
      # nvim-dap-ui # Debugger UI
      # nvim-dap-virtual-text # Debugger UI
      # cmp-git # Git commits messages as cmp source
      # trouble-nvim # Better presentation of messages
      # cmp-cmdline # Nvim commands line mode completion source
      # cmp-nvim-lsp-signature-help
      # cmp-zsh # ZSH completions in Neovim
      # copilot-lua # GitHub copilot
      # copilot-cmp # GitHub copilot completions
      # nvim-ts-autotag # Auto close tags
      # conform-nvim # Autoformatter
      # nvim-surround # Surround text with symbols
      # nvim-lint # Linters adapter
      # cmp-tabnine # AI code completion
      # cmp-fuzzy-buffer # Buffer content as cmp source
      # cmp-fuzzy-path # FS path as cmp source
      # cmp-dap # Debugging messages as cmp source

      ##### Search & Move #####
      telescope-nvim # Fuzzy search & navigate files & code
      # leap-nvim # Navigate efficiently in code
      # telescope-fzf-native-nvim # Fuzzy search & navigate
      # telescope-media-files-nvim # Works with hacky ueberzug
      # hop-nvim # Navigate efficiently in code

      ##### Techno & Language Specifics #####
      # typst-vim # Typst
      # nabla-nvim # Render maths formulas
      # neorg # Modern oganization markup # Currently lacks a mobile app
      # orgmode # Organization markup # Has Orgzly mobile app
      # quarto-nvim # Publishing system
      # nvim-jdtls # Java (Eclipse)
      # go-nvim # Go
      # vim-go # Go (Vimscript)
      # grammar-guard-nvim
      # zk-nvim # zk integration
      # markdown-preview-nvim # Markdown previewing
      # nvim-dap-python # Use dap with debugpy

      ##### Deprecated #####
      # none-ls-nvim # Reload of a deprecated plugin
      # lsp-zero-nvim # Easier lsp config for neovim
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = false;
    withRuby = true;
  };

  home.file = {
    dprint-config = {
      target = ".dprint.json";
      source = ./plugin/dprint.json;
    };
  };

  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text editor";
    settings."GenericName[fr]" = "Éditeur de texte";
    comment = "Edit text files";
    settings."Comment[fr]" = "Éditer des fichiers texte";
    # settings.TryExec = "${pkgs.neovim}/bin/nvim";
    settings.TryExec = "nvim";
    terminal = true; # Doesn’t work all the time
    # terminal = false; # We want xdg-open to open it in new window
    # exec = "env SHELL=zsh ${term.cmd} ${term.exec} nvim %F";
    type = "Application";
    settings.Keywords = "text;editor;";
    settings."Keywords[fr]" = "texte;éditeur;";
    icon = "nvim";
    categories = [ "Utility" "TextEditor" ];
    startupNotify = false;
    mimeType = [
      "text/english"
      "text/french"
      "text/plain"
      "text/x-makefile"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "application/x-shellscript"
      "text/x-c"
      "text/x-c++"
    ];
  };
}
