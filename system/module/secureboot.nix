{ lib, ... }:
{
  boot = {
    loader.systemd-boot.enable = lib.mkForce false; # Disabled for secure boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    # bootspec.enable = true; # Additional info for Secure Boot support
  };
}
