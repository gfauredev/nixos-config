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
        default = "${config.user.home}/author/nixOsConfig";
        description = "Configuration Flake repository full path";
      };
      # dev-templates = mkOption {
      #   type = str; # Hardcoded in config.nu TODO Use this in nushell, not via env var
      #   default = "${config.home.sessionVariables.CODE_DIR}/dev-templates";
      #   description = "Dev environments templates Flake repository full path";
      # };
    };
}
