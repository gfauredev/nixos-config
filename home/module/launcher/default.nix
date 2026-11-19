{
  pkgs-unstable,
  lib,
  ...
}:
{
  imports = [ ./vicinae ];

  options.launch = with lib.types; {
    all = lib.mkOption {
      type = str;
      default = "${pkgs-unstable.vicinae}/bin/vicinae toggle"; # Assumes already running
      description = "General laucher command";
    };
    # alt = lib.mkOption {
    #   type = str;
    #   default = "albert toggle"; # Fallback, must already run
    #   description = "Alternative general launcher";
    # };
    app = lib.mkOption {
      type = str;
      default = "${pkgs-unstable.vicinae}/bin/vicinae vicinae://launch/applications";
      description = "Application launcer";
    };
    pass = lib.mkOption {
      type = str;
      default = "${pkgs-unstable.vicinae}/bin/vicinae open --query 'pass '";
      description = "Quick password manager";
    };
    calc = lib.mkOption {
      type = str;
      default = "${pkgs-unstable.vicinae}/bin/vicinae vicinae://launch/calculator";
      description = "Quick calculator";
    };
    mix = lib.mkOption {
      type = str;
      default = "${pkgs-unstable.pwvucontrol}/bin/pwvucontrol"; # Audio mixer
      description = "Audio mixer";
    };
  };

  config.home.packages = with pkgs-unstable; [
    libqalculate # Calculation library used by launchers
  ];
}
