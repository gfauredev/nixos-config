{ lib, config, ... }: # Terminal emulators
{
  imports = [
    ./ghostty
    ./foot
    # ./alacritty
  ];
  options.term =
    with lib;
    let
      str = types.str;
    in
    {
      name = mkOption {
        type = str;
        default = "ghostty";
        description = "Main terminal window title or class";
      };
      cmd = mkOption {
        type = str;
        default = "ghostty"; # Main, full-featured terminal
        description = "Main terminal command";
      };
      desktop = mkOption {
        type = str;
        default = "com.mitchellh.ghostty";
        description = "Main terminal desktop entry name (without .desktop)";
      };
      exec = mkOption {
        type = str;
        default = "-e";
        description = "Main terminal option to execute a command";
      };
      alt = {
        name = mkOption {
          type = str;
          default = "foot";
          description = "Alternative terminal window title or class";
        };
        cmd = mkOption {
          type = str;
          default = "foot"; # Alternative, fallback terminal
          description = "Alternative terminal command";
        };
        exec = mkOption {
          type = str;
          default = "-e";
          description = "Alternative terminal option to execute a command";
        };
      };
      # alt = {
      #   name = mkOption {
      #     type = str;
      #     default = "alacritty";
      #     description = "Alternative terminal window title or class";
      #   };
      #   cmd = mkOption {
      #     type = str;
      #     default = "alacritty"; # Alternative, fallback terminal
      #     description = "Alternative terminal command";
      #   };
      #   exec = mkOption {
      #     type = str;
      #     default = "--command";
      #     description = "Alternative terminal option to execute a command";
      #   };
      # };
    };
  config.home.sessionVariables = {
    TERM = config.term.cmd; # Default terminal emulator
    TERMINAL = config.term.cmd; # Default terminal emulator
  };
}
