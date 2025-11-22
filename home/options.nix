{ lib, config, ... }:
{
  options =
    with lib;
    with types;
    {
      user = mkOption {
        type = attrsOf anything; # TODO type more precisely
        description = "Home user definition (including email…)";
      };
      location = mkOption {
        type = str;
        default = "${config.user.home}/code/config";
        description = "Configuration Flake repository full path";
      };
      # media = mkOption {
      #   type = str;
      #   default = "spotify"; # Preferred media app
      #   description = "Command to quick launch with shortcut (like XF86AudioMedia)";
      # };
    };
}
