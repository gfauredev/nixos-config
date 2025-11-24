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
        default = "${config.home.sessionVariables.CODE_DIR}/config";
        description = "Configuration Flake repository full path";
      };
      dev-templates = mkOption {
        type = str;
        default = "${config.home.sessionVariables.CODE_DIR}/dev-templates";
        description = "Dev environments templates Flake repository full path";
      };
    };
}
