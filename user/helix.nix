{ pkgs, config, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "custom";
      editor = {
        cursor-shape = {
          normal = "block";
          insert = "bar";
          # select = "block";
          # replace = "underline";
        };
      };
      keys.normal = {
        "’" = "command_mode";
        c = "move_char_left";
        t = "move_line_down";
        s = "move_line_up";
        r = "move_char_right";
        h = "find_till_char";
        H = "till_prev_char";
        j = "replace";
        J = "replace_with_yanked";
        k = "select_regex";
        K = "split_selection";
        l = "change_selection";
        L = "copy_selection_on_next_line";
      };
      keys.select = {
        "’" = "command_mode";
        c = "extend_char_left";
        t = "extend_line_down";
        s = "extend_line_up";
        r = "extend_char_right";
        h = "find_till_char";
        H = "till_prev_char";
        j = "replace";
        J = "replace_with_yanked";
        k = "select_regex";
        K = "split_selection";
        l = "change_selection";
        L = "copy_selection_on_next_line";
      };
    };
    themes.custom = {
      "inherits" = "onedarker";
      "ui.background" = "transparent";
    };
  };
}
