# My main laptop, a Framework Laptop 13
{ pkgs, ... }:
{
  imports = [
    ../.
    ./hardware.nix
    ../../module/virtualization.nix
  ];

  # nix = {
  #   settings = {
  #     substituters = [ "https://cache.nixos.org" ];
  #     trusted-public-keys = [
  #       "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #     ];
  #   };
  # };

  boot = {
    bootspec.enable = true;
    loader.systemd-boot.enable = false; # Disabled for secure boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  networking = {
    hostName = "griffin";
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22000 # Syncthing
        2049 # Vagrant
      ];
      allowedUDPPorts = [
        22000 # Syncthing
        21027 # Syncthing
        2049 # Vagrant
      ];
    };
    wireguard.enable = true;
  };

  environment.systemPackages = with pkgs; [
    framework-tool # Hardware related tools for framework laptops
  ];

  # services.fwupd = {
  #   extraRemotes = [ "lvfs-testing" ];
  # };

  system.stateVersion = "25.05";
}
