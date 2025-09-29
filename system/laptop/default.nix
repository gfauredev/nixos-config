{
  lib,
  pkgs,
  ...
}: # Common configuration for laptops
{
  imports = [
    ../default.nix
    ../module/pc.nix
    ../module/i18n.nix
  ];

  boot.kernelParams = [ "mem_sleep_default=deep" ]; # Suspend then Hibernate

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
  '';

  services = {
    power-profiles-daemon.enable = true; # Suspend the Hibernate
    fprintd.enable = lib.mkDefault true; # Support fingerprint readers
    logind = {
      powerKey = "suspend";
      powerKeyLongPress = "reboot";
      lidSwitch = "suspend-then-hibernate";
      # settings.Login = {
      #   HandlePowerKey = "suspend";
      #   HandleLidSwitch = "suspend";
      # };
    };
  };

  environment.systemPackages = [ pkgs.brightnessctl ]; # Keyboard brightness control
}
