{ lib, ... }: { # Terminal emulators
  imports = [ ./ghostty ./alacritty ./wezterm ];

  options.term = {
    name = lib.mkOption { # Main, full-featured terminal
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
    alt = { # Alternative, fallback terminal
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
    };
  };
}
