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

  # boot.kernelParams = [ "mem_sleep_default=deep" ]; # Suspend then Hibernate
  # systemd.sleep.extraConfig = '' FIXME makes Framework Laptop 13 Intel 12 bootloop
  #   HibernateDelaySec=30m
  #   SuspendState=mem
  # '';

  services = {
    # power-profiles-daemon.enable = true; # Suspend the Hibernate
    fprintd.enable = lib.mkDefault true; # Support fingerprint readers
  };

  environment.systemPackages = [ pkgs.brightnessctl ]; # Keyboard brightness control
}
