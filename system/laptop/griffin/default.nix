# My main laptop, a Framework Laptop 13
{ pkgs, ... }: {
  imports = [
    ../.
    ./hardware.nix
    ../../module/virtualization.nix
    ../../module/gaming.nix
    # ../../module/nvidia.nix
  ];

  nix = {
    settings = {
      substituters = [ "https://cache.nixos.org" ]; # TEST explicit relevance
      # extra-substituters = [ # Use --option extra-substituters
      #   "http://192.168.1.4:5000" # Desktop as local binary cache
      # ];
      # trusted-substituters = [
      #   "http://192.168.1.4:5000" # Desktop as local binary cache
      # ];
      trusted-public-keys = [
        # "192.168.1.4:M2RK6BgauXFtWIrs9y6Kvw8ptFLUyOmW0PsSjOvKuks="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  };

  # hardware.framework.enableKmod = false; # FIX bug in NixOS Hardware

  boot = {
    # extraModprobeConfig = ''
    #   options snd_usb_audio vid=0x1235 pid=0x8210 device_setup=1
    # '';
    # Last line above is used for Focusrite sound interfaces
    bootspec.enable = true;
    loader.systemd-boot.enable = false; # Disabled for secureboot
    # kernelPackages = pkgs.linuxPackages_6_12; # Pin major Linux kernel version
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  networking = {
    hostName = "griffin";
    firewall = {
      enable = true;
      # Syncthing:22000,21027 | Vagrant:2049
      allowedTCPPorts = [ 22000 2049 ]; # Opened TCP ports
      allowedUDPPorts = [ 22000 21027 2049 ]; # Open UDP ports
      # extraCommands = ''
      #   iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns
      # '';
    };
    wireguard.enable = true;
  };

  environment.systemPackages = with pkgs;
    [
      framework-tool # Hardware related tools for framework laptops
    ];

  # services = {
  #   fwupd = {
  #     extraRemotes = [ "lvfs-testing" ];
  #   };
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
