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
      theme = "custom";
      editor = {
        auto-save = true;
        # auto-save = {
        #   focus-lost = true; # TODO enable
        #   after-delay = {
        #     enabled = true;
        #     timeout = 5000;
        #   };
        # };
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "block";
          # replace = "underline";
        };
        indent-guides.render = true;
        soft-wrap.enable = true;
      };
      keys.normal = { # TODO factorize between normal and select using Nix
        c = "move_char_left"; # h bépo equivalent
        t = "move_line_down"; # k bépo equivalent
        s = "move_line_up"; # j bépo equivalent
        r = "move_char_right"; # l bépo equivalent
        C = "move_prev_long_word_start"; # B alternative
        T = [ # fast down move (5 lines or so)
          "move_line_down"
          "move_line_down"
          "move_line_down"
          "move_line_down"
          "move_line_down"
        ];
        S = [ # fast up move (5 lines or so)
          "move_line_up"
          "move_line_up"
          "move_line_up"
          "move_line_up"
          "move_line_up"
        ];
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
      keys.normal."C-w" = { # Window mode
        c = "jump_view_left"; # h bépo equivalent
        t = "jump_view_down"; # k bépo equivalent
        s = "jump_view_up"; # j bépo equivalent
        r = "jump_view_right"; # l bépo equivalent
        C = "swap_view_left"; # H bépo equivalent
        T = "swap_view_down"; # K bépo equivalent
        S = "swap_view_up"; # J bépo equivalent
        R = "swap_view_right"; # L bépo equivalent
      };
      keys.select = {
        c = "extend_char_left"; # Why bothering with consistency ?
        t = "extend_line_down"; # Why bothering with consistency ?
        s = "extend_line_up"; # Why bothering with consistency ?
        r = "extend_char_right"; # Why bothering with consistency ?
        # c = "move_char_left"; # h bépo equivalent
        # t = "move_line_down"; # k bépo equivalent
        # s = "move_line_up"; # j bépo equivalent
        # r = "move_char_right"; # l bépo equivalent
        C = "move_prev_long_word_start"; # B alternative
        T = [ # fast down move (5 lines or so)
          "move_line_down"
          "move_line_down"
          "move_line_down"
          "move_line_down"
          "move_line_down"
        ];
        S = [ # fast up move (5 lines or so)
          "move_line_up"
          "move_line_up"
          "move_line_up"
          "move_line_up"
          "move_line_up"
        ];
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
        ai = {
          command = "lsp-ai"; # TODO configure and use for every language
          args = [ ];
        };
      };
    };
    extraPackages = with pkgs;
      [
        helix-gpt # Add LLMs support through LSP
      ];
    themes.custom = {
      "inherits" = "onedarker";
      # "ui.background" = "transparent";
    };
  };
}
