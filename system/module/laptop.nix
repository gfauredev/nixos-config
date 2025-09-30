{
  lib,
  pkgs,
  ...
}: # Common configuration for laptops
{
  imports = [ ./pc.nix ];

  # boot.kernelParams = [ "mem_sleep_default=deep" ]; # Suspend then Hibernate
  # systemd.sleep.extraConfig = '' FIXME bootloops Framework Laptop 13 Intel 12
  #   HibernateDelaySec=30m
  #   SuspendState=mem
  # '';

  services = {
    fprintd.enable = lib.mkDefault true; # Support fingerprint readers
    # power-profiles-daemon.enable = true; # Suspend the Hibernate
  };

  environment.systemPackages = [ pkgs.brightnessctl ]; # Kbd brightness control
}
