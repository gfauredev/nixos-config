{ config, pkgs, ... }:

{
  imports = [
    ./gui.nix # gui settings with wayland and gui users
  ];

  networking.hostName = "gfHpProbook"; # hostname

  boot = {
    loader.systemd-boot.enable = true; # systemd-boot EFI boot loader
    loader.efi.canTouchEfiVariables = false; # Don’t touch buggy UEFI variables
    # loader.efi.efiSysMountPoint = "/boot/efi"; # Separate efi executable
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  system.stateVersion = "22.11";
}
