{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./knight-hardware.nix # Hardware specific conf
  ];

  hardware = {
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      # forceFullCompositionPipeline = true; TEST relevance
      # nvidiaPersistenced = true; TEST relevance
    };
  };

  # specialisation.closed-nvidia.configuration = {
  #   hardware = {
  #     nvidia = {
  #       open = lib.mkForce false;
  #       modesetting.enable = true;
  #       powerManagement.enable = false;
  #       powerManagement.finegrained = false;
  #       nvidiaSettings = true;
  #     };
  #   };
  # };

  boot = {
    loader = {
      systemd-boot.enable = false; # Let lanzaboote boot securely
      efi.canTouchEfiVariables = true; # Don’t touch if buggy UEFI
      efi.efiSysMountPoint = "/boot"; # Separate efi executable
    };
    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  systemd.services = {
    fix-suspend = {
      description = "Send command to kernel to ignore strange input preventing suspend";
      script = "echo GPP0 > /proc/acpi/wakeup";
      wantedBy = [ "multi-user.target" ];
    };
    wireless-WoL = {
      description = "Enable wireless wake-on-lan";
      script = "${pkgs.iw}/bin/iw phy0 wowlan enable magic-packet";
      wantedBy = [ "multi-user.target" ];
    };
  };

  networking = {
    hostName = "knight";
    # Syncthing:22000,21027 / Vagrant:2049
    firewall = {
      allowedTCPPorts = [ 22 80 443 22000 2049 ]; # Opened TCP ports firewall
      allowedUDPPorts = [ 22000 21027 2049 ]; # Open UDP ports firewall
    };
    useDHCP = false;
    # networkmanager.enable = false;
    # wireless.iwd.enable = true;
    # wireless.enable = true;
    interfaces = {
      wlp6s0 = {
        ipv6.addresses = [
          {
            address = "2a01:e0a:517:3571::1"; # WARNING Access point dependent
            prefixLength = 64;
          }
        ];
        # ipv4.addresses = [
        #   {
        #     address = "192.168.1.21"; # FIXME
        #     prefixLength = 24;
        #   }
        # ];
      };
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "wlp6s0";
    };
    # TODO IPv6 config
  };

  security = {
    pam.services = {
      swaylock = { };
      i3lock = { };
    };
  };

  environment.systemPackages = with pkgs; [
    # rustdesk-server # Remote desktop # TEST if better than steam streaming
    # sunshine # Game streaming server # TEST if better than rustdesk
    mesa
  ];

  services = {
    # fwupd = {
    #   extraRemotes = [ "lvfs-testing" ];
    # };
    openssh = {
      enable = true; # Enable the OpenSSH daemon
      settings = {
        PermitRootLogin = "no";
        LogLevel = "VERBOSE"; # So that fail2ban can observe failed logins
        PasswordAuthentication = false;
      };
    };
    fail2ban = {
      enable = true;
    };
    xserver.videoDrivers = [ "nvidia" ];
  };

  # Music production, mainly for realtime
  musnix = {
    enable = true;
    kernel = {
      realtime = true; # WARNING needs to compile kernel
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
