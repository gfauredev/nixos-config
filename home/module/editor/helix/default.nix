{ ... }: {
  # See https://docs.helix-editor.com
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "catppuccin-trans"; # TODO Stylix
      editor = {
        auto-format = true;
        auto-save = {
          # focus-lost = true;
          after-delay = {
            enable = true;
            timeout = 3000;
          };
        };
        soft-wrap.enable = true;
        line-number = "relative";
        cursor-shape = {
          normal = "underline";
          select = "block";
          insert = "bar";
        };
        indent-guides.render = true;
        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "error";
        };
        lsp = {
          display-progress-messages = true;
          display-inlay-hints = true;
        };
      };
      keys = let
        mult = 8; # Quicker movements multiplier
        default = {
          c = "move_char_left"; # h bépo equivalent
          t = "move_visual_line_down"; # k bépo equivalent
          s = "move_visual_line_up"; # j bépo equivalent
          r = "move_char_right"; # l bépo equivalent
          C = "extend_to_line_start"; # B, quicker vgl
          # C = "move_prev_long_word_start"; # B alternative
          T = builtins.genList (x: "move_visual_line_down") mult; # j×8 quicker
          S = builtins.genList (x: "move_visual_line_up") mult; # k×8 quicker
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
          ret = ":write"; # "open_below"; # Quickly write file (Return)
          S-ret = ":write-quit!"; # "open_above"; # Force write & quit (Return)
          C-ret = ":write-buffer-close!"; # Force write & quit buffer (Return)
          D = [ "extend_line_below" "delete_selection" ]; # Delete line
          space.t = "goto_word"; # Jump to a tag
          X = "keep_selections";
          A-X = "remove_selections";
        };
        window = { # Window sub mode
          c = "jump_view_left"; # h bépo equivalent
          t = "jump_view_down"; # k bépo equivalent
          s = "jump_view_up"; # j bépo equivalent
          r = "jump_view_right"; # l bépo equivalent
          C = "swap_view_left"; # H bépo equivalent
          T = "swap_view_down"; # K bépo equivalent
          S = "swap_view_up"; # J bépo equivalent
          R = "swap_view_right"; # L bépo equivalent
          v = "vsplit"; # Vertical right split
          w = "vsplit"; # Vertical right split
          h = "hsplit"; # Horizontal bottom split
          W = "hsplit"; # Horizontal bottom split
        };
      in {
        normal = default // {
          "C-w" = window;
          space = {
            u = "select_references_to_symbol_under_cursor"; # Select all Usages
            U = "goto_reference"; # Select a Usage to go to
            h = "hover"; # Show Help
            space = "command_palette"; # Show all the commands
            w = window;
          };
          g = { # GO TO
            # g = "goto_file_start"; # Default
            # e = "goto_last_line"; # Default
            # f = "goto_file"; # Default
            c = "goto_line_start";
            T = "move_line_down";
            S = "move_line_up";
            r = "goto_line_end";
            space = "goto_first_nonwhitespace";
            F = "goto_last_modified_file";
            m = "goto_window_center";
            k = "goto_reference";
            u = "goto_reference";
            h = "hover";
            R = "goto_reference";
            d = "goto_definition";
            l = "goto_declaration";
          };
          "#" = { # "#" sub mode (shell or files related commands)
            # Open most recently edited PDF file
            p = ":run-shell-command xdg-open $(ls --sort=time *.pdf|head -n1)";
          };
          z = { # View mode
            c = "align_view_center";
            t = "scroll_down";
            s = "scroll_up";
            r = "align_view_top";
            T = "page_down";
            S = "page_up";
            b = "align_view_bottom";
          };
        };
        select = default // {
          c = "extend_char_left"; # h bépo equivalent
          t = "extend_line_down"; # j bépo equivalent
          s = "extend_line_up"; # k bépo equivalent
          r = "extend_char_right"; # l bépo equivalent
          T = builtins.genList (x: "extend_line_down") mult; # j×8 quicker
          S = builtins.genList (x: "extend_line_up") mult; # k×8 quicker
        };
      };
    };
    languages = {
      # See https://docs.helix-editor.com/languages.html
      # WARN keep up to date with upstream:
      # https://github.com/helix-editor/helix/blob/master/languages.toml
      language = [
        {
          name = "nix";
          language-servers = [ "nil" "nixd" "harper" "llm" ];
          auto-format = true;
          formatter.command = "nixfmt";
        }
        {
          name = "python";
          language-servers = [ "ty" "ruff" "harper" "llm" ]; # "jedi" "pylsp"
          auto-format = true;
        }
        {
          name = "typst";
          language-servers = [ "tinymist" "ltex-fr" "llm" ];
          auto-format = true;
          formatter = {
            command = "typstyle";
            args = [ "--line-width=80" "--indent-width=2" "--wrap-text" ];
          };
        }
        {
          name = "markdown";
          language-servers =
            [ "marksman" "markdown-oxide" "dprint" "ltex-fr" "llm" ];
          auto-format = true;
        }
        {
          name = "c";
          file-types = [ "c" "h" ];
          language-servers = [ "clangd" "harper" "llm" ];
          auto-format = true;
        }
        {
          name = "java";
          language-servers = [ "jdtls" "harper" "llm" ];
          auto-format = true;
        }
        {
          name = "bash";
          language-servers = [ "bash-language-server" "harper" "llm" ];
          auto-format = true;
        }
        {
          name = "javascript";
          language-servers = [ "typescript-language-server" "harper" "llm" ];
          auto-format = true;
        }
        {
          name = "typescript";
          language-servers = [ "typescript-language-server" "harper" "llm" ];
          auto-format = true;
        }
        {
          name = "jsx";
          language-servers = [ "typescript-language-server" "harper" "llm" ];
          auto-format = true;
        }
        {
          name = "git-commit";
          language-servers = [ "harper" "llm" ];
          auto-format = true;
        }
        {
          name = "git-rebase";
          language-servers = [ "harper" "llm" ];
          auto-format = true;
        }
        # {
        #   name = "sql";
        #   language-servers = [ "sqls" ];
        #   auto-format = true;
        # }
      ];
      language-server = {
        dprint = {
          command = "dprint";
          args = [ "lsp" ];
        };
        harper = {
          command = "harper-ls";
          args = [ "--stdio" ];
        };
        tinymist.config = {
          lint.enabled = true;
          projectResolution = "lockDatabase"; # FIXME define project main file
          preview.background = {
            enabled = true; # Preview the Typst file
            args = [
              "--open" # Auto open in browser
              "--invert-colors=never" # Real colors
            ];
          };
          # preview.browsing.args = [
          #   "--open" # Auto open in browser
          #   "--invert-colors=never" # Real colors
          # ];
        };
        ty = {command="ty"; args = [ "server" ];};
        ruff = {command="ruff"; args = [ "server" ];};
        # sqls = { command = "sqls"; };
      };
    };
    themes = {
      catppuccin-trans = {
        inherits = "catppuccin_mocha";
        "ui.background" = "transparent";
      };
      # jetbrains-trans = {
      #   inherits = "jetbrains_dark";
      #   "ui.background" = "transparent";
      # };
      # base16-trans = {
      #   inherits = "base16_default_dark";
      #   "ui.background" = "transparent";
      # };
      # tokyo-trans = { # FIXME
      #   inherits = "tokyonight";
      #   "ui.background" = "transparent";
      # };
      # gruvbox-trans = {
      #   inherits = "gruvbox_dark_hard";
      #   "ui.background" = "transparent";
      # };
    };
  };
}
