{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./gui.nix # main user settings, with graphical env
    ./virtualisation.nix # virtualisation setup
    # /etc/nixos/cachix.nix # binary cache
  ];

  networking = {
    hostName = "gfDesktop0"; # Define hostname
    firewall.allowedTCPPorts = [ 22 80 443 22000 ]; # Opened TCP ports firewall
    firewall.allowedUDPPorts = [ 22000 21027 ]; # Open UDP ports firewall
  };

  boot = {
    loader.systemd-boot.enable = true; # Use the systemd-boot EFI boot loader
    loader.efi.canTouchEfiVariables = true; # Don’t touch if buggy UEFI
    loader.efi.efiSysMountPoint = "/boot"; # Separate efi executable
    # pin a specific kernel version that works with this hardware
    # kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_0.override {
    #   argsOverride = rec {
    #     src = pkgs.fetchurl {
    #       url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    #       # sha256 = "Z9rMK3hgWlbpl/TAjQCb6HyY7GbxhwIgImyLPMZ2WQ8=";# 6.0.7
    #     };
    #     version = "6.0.7";
    #     modDirVersion = "6.0.7";
    #   };
    # });
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "nvme.noacpi=1"
    ];
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
    # xserver.videoDrivers = [ "modesetting" ];
    # xserver.videoDrivers = [ "modesetting" "nvidia" ];
    fwupd.enable = true;
    tlp.enable = true; # To save some power
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    nvidia = {
      # open = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        # sync = {
        #   enable = true;
        #   allowExternalGpu = true;
        # };
        # offload.enable = true;
      };
      powerManagement.enable = true;
      nvidiaSettings = true;
      forceFullCompositionPipeline = true;
      # nvidiaPersistenced = true;
    };
  };

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
