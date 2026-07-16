{
  pkgs,
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

  hardware.sensor.iio.enable = true; # Gyroscope & light sensor

  services = {
    fprintd.enable = lib.mkDefault true; # Support fingerprint readers
    illum.enable = true; # Brightness control
  };

  # programs.iio-hyprland.enable = true; # Auto orient Hyprland

  environment.systemPackages = with pkgs; [
    wluma # Auto brightness screen content ambient light TODO configure
  ];
}
