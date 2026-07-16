{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./vicinae
    ./albert
  ];

  options.launch = with lib.types; {
    all = lib.mkOption {
      type = str;
      default = "${pkgs.vicinae}/bin/vicinae toggle"; # Assumes already running
      description = "General laucher command";
    };
    alt = lib.mkOption {
      type = str;
      default = "${pkgs.albert}/bin/albert toggle"; # Fallback, must already run
      description = "Alternative general launcher";
    };
    app = lib.mkOption {
      type = str;
      default = "${pkgs.vicinae}/bin/vicinae toggle"; # TODO Properly
      # default = ''albert show "app "''; # Application launcher
      description = "Application launcer";
    };
    category = lib.mkOption {
      type = str;
      default = "${pkgs.vicinae}/bin/vicinae toggle"; # TODO Properly
      # default = "rofi -show drun -drun-categories";
      description = "Launch application by category";
    };
    pass = lib.mkOption {
      type = str;
      default = "${pkgs.vicinae}/bin/vicinae toggle"; # TODO Properly
      # default = ''albert show "pass "'';
      description = "Quick password manager";
    };
    calc = lib.mkOption {
      type = str;
      default = "${pkgs.vicinae}/bin/vicinae toggle"; # TODO Properly
      # default = ''albert show "= "''; # Quick calculator
      description = "Quick calculator";
    };
    mix = lib.mkOption {
      type = str;
      default = "${config.term.cmd} ${config.term.exec} pulsemixer"; # Audio mixer
      description = "Audio mixer";
    };
  };

  config.home.packages = with pkgs; [
    libqalculate # Calculation library used by launchers
  ];
}
