{ config, ... }: {
  imports = [ ./hardware.nix ../default.nix ];

  nix = {
    settings = {
      substituters = [ "https://cache.nixos.org" ];
      # extra-substituters = [ # Use --option extra-substituters
      #   "http://192.168.1.4:5000" # Desktop as local binary cache
      # ];
      trusted-substituters = [
        "http://192.168.1.4:5000" # Desktop as local binary cache
      ];
      trusted-public-keys = [
        "192.168.1.4:M2RK6BgauXFtWIrs9y6Kvw8ptFLUyOmW0PsSjOvKuks="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        # "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
    };
  };

  hardware = {
    nvidia = {
      open = false;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      # forceFullCompositionPipeline = true; TEST relevance
      # nvidiaPersistenced = true; TEST relevance
    };
    nvidia.prime = {
      allowExternalGpu = true;
      # offload = {
      #   enable = true;
      #   enableOffloadCmd = true;
      # };
      # sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:127:0:0";
    };
  };

  boot = {
    # extraModprobeConfig = ''
    #   options snd_usb_audio vid=0x1235 pid=0x8210 device_setup=1
    # '';
    # Last line above is used for Focusrite sound interfaces
    bootspec.enable = true;
    loader.systemd-boot.enable = false; # Disabled for secureboot
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

  services = {
    fwupd = {
      # extraRemotes = [ "lvfs-testing" ];
    };
    fprintd = {
      enable = true; # Support figerprint reader
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
