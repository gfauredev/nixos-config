{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./wox # To TEST
    ./ulauncher # To TEST
    ./rofi # To TEST, improve
    ./albert
  ];

  options.launch = {
    all = lib.mkOption {
      # type = lib.types.str;
      default = "albert toggle"; # Assumes Albert already started
      # default = "pgrep albert || albert; albert toggle"; # Lazy start
      description = "General laucher command";
    };
    alt = lib.mkOption {
      default = "rofi -show combi -combi-modes"; # Alternative, fallback
      description = "Alternative general launcher";
    };
    alt2 = lib.mkOption {
      default = "wox"; # Alternative, fallback
      description = "Alternative general launcher";
    };
    app = lib.mkOption {
      default = ''albert show "app "''; # Application launcher
      description = "Application launcer";
    };
    category = lib.mkOption {
      default = "rofi -show drun -drun-categories";
      description = "Launch application by category";
    };
    pass = lib.mkOption {
      default = ''albert show "pass "'';
      description = "Quick password manager";
    };
    calc = lib.mkOption {
      default = "${config.term.cmd} ${config.term.exec} kalker";
      description = "Quick calculator";
    };
  };

  config.home.packages = with pkgs; [
    libqalculate # Calculation library used by launchers
  ];
}
