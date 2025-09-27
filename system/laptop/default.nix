{
  lib,
  pkgs,
  config,
  ...
}: # Common configuration for laptops
{
  imports = [
    ../default.nix
    ../module/pc.nix
    ../module/i18n.nix
  ];

  services = {
    fprintd.enable = lib.mkDefault true; # Support fingerprint readers
    logind = {
      powerKey = "suspend";
      lidSwitch = "suspend";
      # settings.Login = {
      #   HandlePowerKey = "suspend";
      #   HandleLidSwitch = "suspend";
      # };
    };
  };

  environment.systemPackages = [ pkgs.brightnessctl ]; # Keyboard brightness control
}
