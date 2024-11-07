{ pkgs, ... }: {
  home.packages = with pkgs;
    [
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
          # replace = "underline";
        };
        indent-guides.render = true;
      };
      keys = let
        default = {
          c = "move_char_left"; # h bépo equivalent
          t = "move_visual_line_down"; # k bépo equivalent
          s = "move_visual_line_up"; # j bépo equivalent
          r = "move_char_right"; # l bépo equivalent
          C = "move_prev_long_word_start"; # B alternative
          T = builtins.genList (x: "move_visual_line_down")
            8; # j×8 quick alternative
          S = builtins.genList (x: "move_visual_line_up")
            8; # k×8 quicker alternative
          R = "move_next_long_word_end"; # E alternative
          h = "find_till_char"; # t replacement
          H = "till_prev_char"; # T replacement
          j = "replace"; # r replacement
          J = "replace_with_yanked"; # R replacement
          k = "select_regex"; # s replacement
          K = "split_selection"; # S replacement
          l = "change_selection"; # c replacement
          L = "copy_selection_on_prev_line"; # A-c replacement
          C-l = "copy_selection_on_next_line"; # C replacement
          A-l = [ # Quick A-c + C replacement
            "copy_selection_on_prev_line"
            "copy_selection_on_next_line"
          ];
          "’" = "command_mode"; # : bépo quicker alternative
          "»" = "indent"; # > bépo quicker alternative
          "«" = "unindent"; # < bépo quicker alternative
          ret = "open_below"; # o alternative (Return)
          S-ret = "open_above"; # o alternative (Return)
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
        };
        select = default // {
          c = "extend_char_left"; # Why bothering with consistency ?
          t = "extend_line_down"; # Why bothering with consistency ?
          s = "extend_line_up"; # Why bothering with consistency ?
          r = "extend_char_right"; # Why bothering with consistency ?
          T =
            builtins.genList (x: "extend_line_down") 8; # j×8 quick alternative
          S =
            builtins.genList (x: "extend_line_up") 8; # k×8 quicker alternative
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
          name = "typst";
          language-servers = [ "tinymist" "typst-lsp" "ltex" "llm" ];
          auto-format = true;
          formatter.command = "typstyle"; # FIXME
        }
        {
          name = "markdown";
          # roots = [ ".marksman.toml" ];
          language-servers =
            [ "marksman" "markdown-oxide" "dprint" "ltex" ]; # "llm" ];
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
          language-servers = [ "ltex" "llm" ];
        }
        {
          name = "git-rebase";
          language-servers = [ "ltex" "llm" ];
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
          language-servers = [ "ltex" "llm" ];
          auto-format = false;
        }
      ];
      language-server = {
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
        dprint = {
          command = "dprint";
          args = [ "lsp" ];
        };
        llm = {
          command = "helix-gpt";
          args = [ # WARNING setup secret storage like sops for this TODO
            "--handler"
            "copilot"
            "--copilotApiKey"
            "hey"
          ];
        };
        # ai = {
        #   command = "lsp-ai"; # TODO configure and use for every language
        #   args = [ ];
        # };
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
      explain # Explain system call errors
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
