{ pkgs, stablepkgs, ... }: {
  home.packages = with pkgs; [
    tabby # Self-hosted AI code assistant
    tabby-agent # LSP agent for Tabby
    # nodejs # NodeJS (may be needed by tabby-agent)
    helix-gpt # Add LLMs support through LSP
  ];

  # See : https://docs.helix-editor.com
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "catppuccin-trans";
      editor = {
        auto-save = true;
        auto-format = true;
        # auto-save = {
        #   focus-lost = true; # TODO enable
        #   after-delay = {
        #     enabled = true;
        #     timeout = 5000;
        #   };
        # };
        soft-wrap.enable = true;
        line-number = "relative";
        cursor-shape = {
          normal = "block";
          select = "block";
          insert = "bar";
        };
        indent-guides.render = true;
      };
      keys = let
        qk = 8; # Quicker movements multiplier
        default = {
          c = "move_char_left"; # h bépo equivalent
          t = "move_visual_line_down"; # k bépo equivalent
          s = "move_visual_line_up"; # j bépo equivalent
          r = "move_char_right"; # l bépo equivalent
          C = "extend_to_line_start"; # B, quicker vgl
          # C = "move_prev_long_word_start"; # B alternative
          T = builtins.genList (x: "move_visual_line_down") qk; # j×8 quicker
          S = builtins.genList (x: "move_visual_line_up") qk; # k×8 quicker
          R = "extend_to_line_end"; # E, quicker vgh
          # R = "move_next_long_word_end"; # E alternative
          h = "find_till_char"; # t replacement
          H = "till_prev_char"; # T replacement
          j = "replace"; # r replacement
          J = "replace_with_yanked"; # R replacement
          k = "select_regex"; # s replacement
          K = "split_selection"; # S replacement
          l = "change_selection"; # c replacement
          L = "copy_selection_on_prev_line"; # A-c replacement
          C-l = "copy_selection_on_next_line"; # C replacement
          A-l = [ # A-c + C quicker replacement
            "copy_selection_on_prev_line"
            "copy_selection_on_next_line"
          ];
          "’" = "command_mode"; # : bépo quicker alternative
          "»" = "indent"; # > bépo quicker alternative
          "«" = "unindent"; # < bépo quicker alternative
          ret = "open_below"; # o alternative (Return)
          S-ret = "open_above"; # o alternative (Return)
          D = [ "extend_line_below" "delete_selection" ]; # Delete line
          space.t = "goto_word"; # Jump to a tag
        };
      in {
        normal = default // {
          "C-w" = { # Window sub mode
            c = "jump_view_left"; # h bépo equivalent
            t = "jump_view_down"; # k bépo equivalent
            s = "jump_view_up"; # j bépo equivalent
            r = "jump_view_right"; # l bépo equivalent
            C = "swap_view_left"; # H bépo equivalent
            T = "swap_view_down"; # K bépo equivalent
            S = "swap_view_up"; # J bépo equivalent
            R = "swap_view_right"; # L bépo equivalent
          };
          "#" = { # "#" sub mode (shell or files related commands)
            # Open most recently edited PDF
            p = ":run-shell-command xdg-open $(ls --sort=time *.pdf|head -n1)";
          };
          g = {
            c = "goto_line_start";
            r = "goto_line_end";
            h = "goto_window_center";
            k = "goto_reference";
            D = "goto_definition";
            d.d = "goto_definition";
            d.f = "goto_definition";
            d.c = "goto_declaration";
            d.l = "goto_declaration";
          };
        };
        select = default // {
          c = "extend_char_left"; # h bépo equivalent
          t = "extend_line_down"; # j bépo equivalent
          s = "extend_line_up"; # k bépo equivalent
          r = "extend_char_right"; # l bépo equivalent
          T = builtins.genList (x: "extend_line_down") qk; # j×8 quicker
          S = builtins.genList (x: "extend_line_up") qk; # k×8 quicker
        };
      };
    };
    languages = {
      # See : https://docs.helix-editor.com/languages.html
      # WARN keep up to date with upstream:
      # https://github.com/helix-editor/helix/blob/master/languages.toml
      language = [
        {
          name = "nix";
          # scope = "source.nix";
          # injection-regex = "nix";
          # file-types = [ "nix" ];
          # shebangs = [ ];
          # comment-token = "#";
          # indent = {
          #   tab-width = 2;
          #   unit = "  ";
          # };
          language-servers = [ "nil" "nixd" "llm" ];
          auto-format = true;
          formatter.command = "nixfmt";
        }
        {
          name = "python";
          scope = "source.python";
          injection-regex = "py(thon)?";
          file-types = [
            "py"
            "pyi"
            "py3"
            "pyw"
            "ptl"
            "rpy"
            "cpy"
            "ipy"
            "pyt"
            { glob = ".python_history"; }
            { glob = ".pythonstartup"; }
            { glob = ".pythonrc"; }
            { glob = "SConstruct"; }
            { glob = "SConscript"; }
          ];
          shebangs = [ "python" ];
          roots =
            [ "pyproject.toml" "setup.py" "poetry.lock" "pyrightconfig.json" ];
          comment-token = "#";
          language-servers = [ "ruff" "mypy" ]; # TODO implement mypy server
          indent = {
            tab-width = 4;
            unit = "    ";
          };
        }
        {
          name = "typst";
          language-servers = [ "tinymist" "typst-lsp" "ltex-fr" "llm" ];
          auto-format = true;
          formatter.command = "typstyle"; # FIXME
        }
        {
          name = "typst-en";
          scope = "source.typst";
          injection-regex = "typ(st)?";
          file-types = [ "en.typst" "en.typ" ];
          comment-token = "//";
          block-comment-tokens = {
            start = "/*";
            end = "*/";
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          language-servers = [ "tinymist" "typst-lsp" "ltex-fr" "llm" ];
          formatter.command = "typstyle"; # FIXME
          auto-format = true;
        }
        {
          name = "markdown";
          # roots = [ ".marksman.toml" ];
          language-servers =
            [ "marksman" "markdown-oxide" "dprint" "ltex-fr" ]; # "llm" ];
          auto-format = true;
        }
        {
          name = "java";
          language-servers = [ "jdtls" "llm" ];
          auto-format = true;
        }
        {
          name = "javascript";
          language-servers = [ "typescript-language-server" "llm" ];
        }
        {
          name = "typescript";
          language-servers = [ "typescript-language-server" "llm" ];
        }
        {
          name = "jsx";
          language-servers = [ "typescript-language-server" "llm" ];
        }
        {
          name = "git-commit";
          language-servers = [ "ltex-fr" "llm" ];
        }
        {
          name = "git-rebase";
          language-servers = [ "ltex-fr" "llm" ];
        }
        {
          name = "text";
          scope = "source.text";
          file-types = [ "*" ];
          comment-token = "#";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          language-servers = [ "ltex-fr" "llm" ];
          auto-format = false;
        }
      ];
      language-server = let
        ltex = {
          command = "ltex-ls";
          config.ltex = {
            completionEnable = true;
            language = "fr";
            dictionary = { fr = [ "mdr" ]; };
            additionalRules = {
              enablePickyRules = true;
              motherTongue = "fr";
            };
          };
        };
      in {
        # TODO configure a local LLM and use for every language
        # ai = {
        #   command = "lsp-ai";
        #   args = [ ];
        # };
        tabby = {
          command = "npx";
          args = [ "tabby-agent" "--stdio" ]; # ?
        };
        llm = {
          command = "helix-gpt";
          args = [
            "--handler"
            "copilot"
            "--copilotApiKey"
            # If you find this, please do not use my API key, thanks
            "hey"
          ];
        };
        dprint = {
          command = "dprint";
          args = [ "lsp" ];
        };
        ltex-fr = ltex; # ltex that defaults to en for unsupported filetypes
        ltex-en = ltex // { config.ltex.language = "en-US"; };
        tinymist = { config = { exportPdf = "onType"; }; };
        ruff = {
          command = "ruff";
          args = [ "server" ];
        };
      };
    };
    extraPackages = with pkgs; [
      # tree-sitter # Parser generator tool and builtinsrary
      # (pkgs.tree-sitter.withPlugins
      #   (p: [ p.tree-sitter-c p.tree-sitter-typescript ]))
      # (pkgs.tree-sitter.withPlugins (_: allGrammars))

      nil # Nix LSP
      nixfmt # Nix formatter

      bash-language-server # Bash LSP
      shellcheck # Shell script analysis
      stablepkgs.explain # Explain system call errors
      shfmt # Shell script formatter

      lua-language-server # Lua LSP

      nickel # Configuration generation language
      nls # Nickel LSP

      vscode-langservers-extracted # HTML/CSS/JSON/ESLint
      yaml-language-server # YAML LSP
      taplo # TOML LSP and toolkit

      helix-gpt # Add LLMs support through LSP
      lsp-ai # Language server for language models

      dprint # Pluggable code formatting platform

      # languagetool # Advanced spell checking
      ltex-ls # LSP between languagetool and pure text
      # hunspell # Standard spell checker
      # hunspellDicts.fr-any # French
      # hunspellDicts.en_US # American
      # hunspellDicts.en_GB-ise # British
      # hunspellDicts.es_ES # Spanish

      tinymist # Typst LSP FIXME
      # typst-lsp # Typst LSP # DEPRECATED
      typstyle # Typst formatter
      # typstfmt # Typst formatter # Deprecated
      # markdown-oxide # TODO Obsidian style PKM
      marksman # Smart Markdown links
    ];
    themes = {
      catppuccin-trans = {
        inherits = "catppuccin_mocha";
        "ui.background" = "transparent";
      };
      jetbrains-trans = {
        inherits = "jetbrains_dark";
        "ui.background" = "transparent";
      };
      base16-trans = {
        inherits = "base16_default_dark";
        "ui.background" = "transparent";
      };
      tokyo-trans = { # FIXME
        inherits = "tokyonight";
        "ui.background" = "transparent";
      };
      gruvbox-trans = {
        inherits = "gruvbox_dark_hard";
        "ui.background" = "transparent";
      };
    };
  };
}
