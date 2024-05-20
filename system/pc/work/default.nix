# Work PC
{ pkgs, ... }: {
  imports = [ ./hardware.nix ../default.nix ];

  boot = {
    loader = {
      systemd-boot.enable = false; # Let lanzaboote boot securely
      efi.canTouchEfiVariables = true; # Don’t touch if buggy UEFI
      efi.efiSysMountPoint = "/boot"; # Separate efi executable
    };
    kernelPackages = pkgs.linuxPackages; # Stable Linux kernel
    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  networking = {
    hostName = "gfaure";
    firewall = {
      enable = true;
      # Syncthing:22000,21027 | Vagrant:2049 | nix-serve:5000
      allowedTCPPorts = [ 22 80 443 2049 ]; # Opened TCP ports firewall
      allowedUDPPorts = [ 2049 ]; # Open UDP ports firewall
    };
    useDHCP = false;
    # networkmanager.enable = false;
    # wireless.iwd.enable = true;
    # wireless.enable = true;
    interfaces = {
      wlp6s0 = {
        # ipv6.addresses = [
        #   {
        #     address = "2a01:e0a:517:3571::1"; # FIXME
        #     prefixLength = 64;
        #   }
        # ];
        # ipv4.addresses = [
        #   {
        #     address = "192.168.1.21"; # FIXME
        #     prefixLength = 24;
        #   }
        # ];
      };
    };
    # defaultGateway = {
    #   address = "192.168.1.1"; # FIXME
    #   interface = "wlp6s0";
    # };
    # TODO IPv6 config
  };

  services = {
    openssh = {
      enable = true; # Enable the OpenSSH daemon
      settings = {
        PermitRootLogin = "no";
        LogLevel = "VERBOSE"; # For fail2ban
        PasswordAuthentication = true;
      };
    };
    fail2ban = {
      # TODO configure me
      enable = true;
    };
    # xserver.videoDrivers = [ "nvidia" ];
  };

  system.stateVersion = "23.11"; # Do not change
}
