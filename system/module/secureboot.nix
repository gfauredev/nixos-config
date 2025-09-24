{ lib, ... }:
{
  boot = {
    bootspec.enable = true; # Secure Boot support
    loader.systemd-boot.enable = lib.mkDefault false; # Disabled for secure boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
}
