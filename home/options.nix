{ lib, config, ... }:
{
  options = {
    user = lib.mkOption {
      default = { };
      description = "Home’s user configuration";
    };
    location = lib.mkOption {
      default = "${config.user.home}/code/config";
      description = "Configuration Flake repository path";
    };
    media.favorite = lib.mkOption {
      default = "spotify"; # Preferred media app
      description = "Favorite media app";
    };
  };
}
