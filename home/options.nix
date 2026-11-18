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
        default = "${config.user.home}/.nix-config";
        # default = "${config.user.home}/author/nixOsConfig";
        description = "Configuration Flake repository full path";
      };
      dev-templates = mkOption {
        type = str; # Hardcoded in config.nu
        default = "${config.home.sessionVariables}/author/initDevEnv/main";
        description = "Dev environments templates Flake repository full path";
      };
    };
}
