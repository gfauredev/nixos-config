{ ... }: {
  imports = [
    ./hardware.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true; # Use the systemd-boot EFI boot loader
      efi.efiSysMountPoint = "/boot"; # Separate efi executable
    };
    # kernelParams = [ TEST relevance of each
    #   "quiet"
    #   "udev.log_level=3"
    #   "nvme.noacpi=1"
    # ];
  };

  networking = {
    hostName = "cerberus";
    # Syncthing:22000,21027 / Vagrant:2049
    firewall = {
      allowedTCPPorts = [ 22 80 443 22000 2049 ]; # Opened TCP ports firewall
      allowedUDPPorts = [ 22000 21027 2049 ]; # Open UDP ports firewall
    };
  };

  services = {
    openssh = {
      enable = true; # Enable the OpenSSH daemon
      settings = {
        PermitRootLogin = "no";
        LogLevel = "VERBOSE"; # So fail2ban can observe failed logins
        PasswordAuthentication = false;
      };
    };
    fail2ban = {
      enable = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
