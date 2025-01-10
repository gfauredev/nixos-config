{ ... }: {
  programs = {
    alacritty = {
      enable = true; # Fast terminal emulator
      # See: <https://alacritty.org/config-alacritty.html>
      settings = { # TODO configure
        general = {
          # import = [ ];
          live_config_reload = false;
        };
        window = {
          # opacity = 0.8;
          padding = {
            x = 2;
            y = 2;
          };
        };
        font = {
          # family = "FiraCode Nerd Font";
          size = 11;
        };
        colors = {
          primary = {
            background = "#000000";
            # foreground = "#000000";
          };
        };
      };
    };
  };
}
