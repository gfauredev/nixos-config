{
  lib,
  ...
}: # Common configuration for laptops
{
  imports = [ ./pc.nix ];

  # boot.kernelParams = [ "mem_sleep_default=deep" ]; # Suspend then Hibernate
  # systemd.sleep.extraConfig = '' FIXME bootloops Framework Laptop 13 Intel 12
  #   HibernateDelaySec=30m
  #   SuspendState=mem
  # '';

  hardware = {
    acpilight.enable = true; # TEST Brightness control
    brillo.enable = true; # TEST Brightness control
  };

  services = {
    fprintd.enable = lib.mkDefault true; # Support fingerprint readers
    illum.enable = true; # TEST Brightness control
  };

  # environment.systemPackages = [ pkgs.brightnessctl ]; # Kbd brightness control
}
