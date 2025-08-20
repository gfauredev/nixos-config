{ ... }:
{
  imports = [
    ./hardware.nix
    ../default.nix
  ];

  # nix = {
  #   settings = {
  #     substituters = [ "https://cache.nixos.org" ];
  #     trusted-substituters = [
  #       "http://192.168.1.4:5000" # Desktop as local binary cache
  #     ];
  #     trusted-public-keys = [
  #       "192.168.1.4:M2RK6BgauXFtWIrs9y6Kvw8ptFLUyOmW0PsSjOvKuks="
  #       "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #     ];
  #   };
  # };

  boot = {
    bootspec.enable = true;
    # loader.systemd-boot.enable = false; # Disabled for secureboot TODO
    # lanzaboote = {
    #   enable = true; TODO
    #   pkiBundle = "/etc/secureboot";
    # };
  };

  networking = {
    hostName = "chimera";
    firewall = {
      enable = false;
      # Syncthing:22000,21027 | Vagrant:2049
      allowedTCPPorts = [
        22000
        2049
      ]; # Opened TCP ports
      allowedUDPPorts = [
        22000
        21027
        2049
      ]; # Open UDP ports
      # extraCommands = ''
      #   iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns
      # '';
    };
    # wireguard.enable = true;
  };

  services = {
    fwupd = {
      # extraRemotes = [ "lvfs-testing" ];
    };
    fprintd.enable = false;
  };

  system.stateVersion = "25.05";
}
