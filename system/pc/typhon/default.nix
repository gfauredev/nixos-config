{ pkgs, ... }: {
  imports = [ ./hardware.nix ../default.nix ];

  nix = {
    settings = {
      builders-use-substitutes = true;
      substituters = [ "https://cache.nixos.org" ];
      # trusted-substituters = [ ];
      trusted-public-keys =
        [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = false; # Let lanzaboote boot securely
      efi.canTouchEfiVariables = true; # Don’t touch if buggy UEFI
      efi.efiSysMountPoint = "/boot"; # Separate efi executable
    };
    # kernelPackages = pkgs.linuxPackages; # Default Linux kernel
    # kernelPackages = pkgs.linuxPackages_6_8; # Stable Linux kernel
    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  systemd.services = {
    fix-suspend = {
      description =
        "Send command to kernel to ignore strange input preventing suspend";
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
    hostName = "typhon";
    firewall = {
      enable = true;
      # Syncthing:22000,21027 | Vagrant:2049 | nix-serve:5000
      allowedTCPPorts = [ 22 80 443 2049 22000 ]; # Opened TCP ports firewall
      allowedUDPPorts = [ 2049 21027 22000 ]; # Open UDP ports firewall
    };
    useDHCP = false;
    # networkmanager.enable = false;
    # wireless.iwd.enable = true;
    # wireless.enable = true;
    interfaces = {
      wlp6s0 = {
        ipv6.addresses = [{
          address = "2a01:e0a:517:3571::1"; # WARNING Access point dependent
          prefixLength = 64;
        }];
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

  environment.systemPackages = with pkgs; [ mesa ];

  services = {
    # fwupd = {
    #   extraRemotes = [ "lvfs-testing" ];
    # };
    openssh.enable = true; # Enable the OpenSSH daemon
    nix-serve = {
      enable = true; # Enable distribution of nix build cache
      openFirewall = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
