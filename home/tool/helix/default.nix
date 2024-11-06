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
      theme = "gruvbox-transparent";
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
          scope = "source.nix";
          injection-regex = "nix";
          file-types = [ "nix" ];
          shebangs = [ ];
          comment-token = "#";
          language-servers = [ "nil" "nixd" "llm" ];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          auto-format = true;
          formatter.command = "nixfmt";
        }
        {
          name = "typst";
          scope = "source.typst";
          injection-regex = "typ(st)?";
          file-types = [ "typst" "typ" ];
          comment-token = "//";
          block-comment-tokens = {
            start = "/*";
            end = "*/";
          };
          language-servers = [ "tinymist" "typst-lsp" "llm" ];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          auto-format = true;
          formatter.command = "typstyle"; # FIXME
        }
      ];
      language-server = {
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

      vscode-langservers-extracted # HTML/CSS/JSON/ESLint
      yaml-language-server # YAML LSP
      taplo # TOML LSP and toolkit

      nickel # Configuration generation language
      nls # Nickel LSP

      helix-gpt # Add LLMs support through LSP
      lsp-ai # Language server for language models

      dprint # Pluggable code formatting platform
    ];
    themes.gruvbox-transparent = {
      inherits = "gruvbox_dark_hard";
      "ui.background" = "transparent";
    };
  };
}
