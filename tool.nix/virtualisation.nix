# Test virtualisation configuration
# Help: configuration.nix(5) man page and NixOS manual: ’nixos-help’

{ config, pkgs, ... }:

{
  programs = {
    dconf.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libvirt
    docker-compose
    # looking-glass-client
    # virt-manager
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    docker.enable = true;
    # virtualbox.host = {
    #   enable = true;
    #   enableExtensionPack = true;
    # };
    # vmware.host = {
    #   enable = true;
    # };
  };
}
