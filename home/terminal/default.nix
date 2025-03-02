{ lib, ... }: { # Terminal emulators
  imports = [ ./ghostty ./alacritty ./wezterm ];

  options = {
    term = {
      name = lib.mkOption {
        # type = lib.types.str;
        default = "ghostty";
        description = "terminal window title/class";
      };
      cmd = lib.mkOption {
        default = "ghostty";
        description = "terminal command";
      };
      exec = lib.mkOption {
        default = "-e";
        description = "option to execute a command in place of terminal";
      };
      # TODO with window tag rules https://wiki.hyprland.org/Configuring/Window-Rules/#window-rules-v2
      monitor =
        lib.mkOption { default = "alacritty --class monitoring --command"; };
      note = lib.mkOption {
        default = "alacritty --class note --command"; # Note taking terminal
      };
      menu = lib.mkOption {
        default =
          "alacritty --option window.opacity=0.7 --class menu --command";
      };
    };
    term-alt = {
      name = lib.mkOption {
        default = "alacritty";
        description = "terminal window title/class";
      };
      cmd = lib.mkOption {
        default = "alacritty";
        description = "terminal command";
      };
      exec = lib.mkOption {
        default = "--command";
        description = "option to execute a command in place of terminal";
      };
      # TODO with window tag rules https://wiki.hyprland.org/Configuring/Window-Rules/#window-rules-v2
      monitoring = lib.mkOption {
        default =
          "alacritty --class monitoring --command"; # Monitoring terminal
      };
      note = lib.mkOption {
        default = "alacritty --class note --command"; # Note taking terminal
      };
      menu = lib.mkOption {
        default =
          "alacritty --option window.opacity=0.7 --class menu --command";
      };
    };
  };
}
