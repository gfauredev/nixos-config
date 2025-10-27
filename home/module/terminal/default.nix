{ lib, config, ... }: # Terminal emulators
{
  imports = [
    ./ghostty
    ./alacritty
    # ./foot
  ];
  options.term = {
    name = lib.mkOption {
      # Main, full-featured terminal
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
    alt = {
      # Alternative, fallback terminal
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
  config.home.sessionVariables = {
    TERM = config.term.cmd; # Default terminal emulator
    TERMINAL = config.term.cmd; # Default terminal emulator
    TERM_EXEC = config.term.exec; # Default terminal exec command arg
  };
}
