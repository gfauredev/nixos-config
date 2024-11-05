{ ... }: {
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
      };
      keys.normal = {
        c = "move_char_left"; # h bépo equivalent
        t = "move_line_down"; # k bépo equivalent
        s = "move_line_up"; # j bépo equivalent
        r = "move_char_right"; # l bépo equivalent
        C = "move_prev_long_word_start"; # B alternative
        T = "move_line_down"; # TODO fast down move (5 lines or so)
        S = "move_line_up"; # TODO fast up move (5 lines or so)
        R = "move_next_long_word_end"; # E alternative
        h = "find_till_char"; # t replacement
        H = "till_prev_char"; # T replacement
        j = "replace"; # r replacement
        J = "replace_with_yanked"; # R replacement
        k = "select_regex"; # s replacement
        K = "split_selection"; # S replacement
        l = "change_selection"; # c replacement
        L = "copy_selection_on_next_line"; # C replacement
        A-L = "copy_selection_on_prev_line"; # A-C replacement
        C-L = "copy_selection_on_prev_line"; # A-C replacement
        "’" = "command_mode"; # : bépo quicker alternative
        "»" = "indent"; # > bépo quicker alternative
        "«" = "unindent"; # < bépo quicker alternative
      };
      # keys.normal.Z = { # Quick actions mode (from Vim)
      #   Z = ":write-quit!"; # ZZ from Vim
      #   Q = ":quit!"; # ZZ from Vim
      # };
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
        T = "move_line_down"; # TODO fast down move (5 lines or so)
        S = "move_line_up"; # TODO fast up move (5 lines or so)
        R = "move_next_long_word_end"; # E alternative
        h = "find_till_char"; # t replacement
        H = "till_prev_char"; # T replacement
        j = "replace"; # r replacement
        J = "replace_with_yanked"; # R replacement
        k = "select_regex"; # s replacement
        K = "split_selection"; # S replacement
        l = "change_selection"; # c replacement
        L = "copy_selection_on_next_line"; # C replacement
        "’" = "command_mode"; # : bépo quicker alternative
        "»" = "indent"; # > bépo quicker alternative
        "«" = "unindent"; # < bépo quicker alternative
      };
    };
    themes.custom = {
      "inherits" = "onedarker";
      # "ui.background" = "transparent";
    };
  };
}
