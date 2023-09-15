{ config, pkgs, ... }:
let
  domain = "gfaure";
in
{
  imports = [
    ./common.nix # Common settings between hosts
  ];

  networking.hostName = "gfDbServer"; # hostname

  boot = {
    loader.systemd-boot.enable = true; # systemd-boot EFI boot loader
    loader.efi.canTouchEfiVariables = true; # Don’t touch if buggy UEFI
    # loader.efi.efiSysMountPoint = "/boot/efi"; # efi
    kernelPackages = pkgs.linuxPackages_hardened;
  };

  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      settings = {
        mysqld = {
          lc-time-names = "fr_FR";
        };
      };
    };
    # certbot = {
    #   enable = true;
    #   agreeTerms = true;
    # };
  };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    mysql = { };
    # Change this for real servers
    hashedPassword = "$y$j9T$atvxhqCe0PyyjJyBkyk/a0$nIg6rpjE8zt9Pj4uFY0/qwQF/ihwT.F12He.B/pn2PA";
  };

  system.stateVersion = "22.11";
}
