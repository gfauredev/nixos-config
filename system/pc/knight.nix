{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./knight-hardware.nix # Hardware specific conf
  ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      # forceFullCompositionPipeline = true; TEST relevance
      # nvidiaPersistenced = true; TEST relevance
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true; # Use the systemd-boot EFI boot loader
      # systemd-boot.enable = false; # Let lanzaboote boot securely
      efi.canTouchEfiVariables = true; # Don’t touch if buggy UEFI
      efi.efiSysMountPoint = "/boot"; # Separate efi executable
    };
    bootspec.enable = true;
    # lanzaboote = {
    #   enable = true; # TODO secureboot
    #   pkiBundle = "/etc/secureboot";
    # };
    # kernelParams = [ TEST relevance of each
    #   "quiet"
    #   "udev.log_level=3"
    #   "nvme.noacpi=1"
    # ];
  };

  networking = {
    hostName = "knight";
    # Syncthing:22000,21027 / Vagrant:2049
    firewall = {
      allowedTCPPorts = [ 22 443 22000 2049 ]; # Opened TCP ports firewall
      allowedUDPPorts = [ 22000 21027 2049 ]; # Open UDP ports firewall
    };
  };

  security = {
    pam.services = {
      swaylock = { };
      i3lock = { };
    };
  };

  services = {
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

  # Set your system kind (needed for flakes)
  # nixpkgs.hostPlatform = "x86_64-linux";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
