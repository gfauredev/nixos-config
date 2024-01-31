{ lib, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  # hardware.enableAllFirmware = true;

  boot = {
    # Enable SysRq keys (reboot/off:128, kill:64, sync:16, kbdControl: 4)
    kernel.sysctl = { "kernel.sysrq" = 212; };
    # kernelPackages = pkgs.linuxPackages; # Stable Linux kernel
    kernelPackages = pkgs.linuxPackages_latest; # Latest Linux kernel
    supportedFilesystems = [ "bcachefs" ]; # Add support for bcachefs
  };

  networking.wireless.enable = false;

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    git = {
      enable = true;
      lfs.enable = true;
      config = {
        init.defaultBranch = "main";
        user = {
          email = "pro@gfaure.eu";
          name = "Guilhem Fauré";
        };
      };
    };
  };

  environment = {
    shellAliases = {
      clone = "git clone https://gitlab.com/gfauredev/nixos-config.git"; # Easilly clone this repo
      clone-ssh = "git clone git@gitlab.com:gfauredev/nixos-config.git"; # Easilly clone this repo with SSH
    };
  };

  # users.users.nixos = {
  #   password = "password"; # Directly able to login via SSH
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ];
  # };

  services = {
    openssh = {
      enable = true; # Enable the OpenSSH daemon
      settings = {
        PasswordAuthentication = true; # Prevent the need to setup a key
        PermitRootLogin = "yes"; # Easily login as root via SSH
        LogLevel = "VERBOSE"; # So that fail2ban can observe failed logins
      };
    };
    # nfs.server.enable = lib.mkDefault true;
  };
}
