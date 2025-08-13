{ lib, ... }:
{
  imports = [
    ../default.nix
    # ../module/pc.nix
  ];

  # hardware.enableAllFirmware = true;

  boot = {
    # Enable SysRq keys (reboot/off:128, kill:64, sync:16, kbdControl: 4)
    kernel.sysctl = {
      "kernel.sysrq" = 212;
    };
    # kernelPackages = pkgs.linuxPackages; # Stable Linux kernel
    # kernelPackages = pkgs.linuxPackages_latest; # Latest Linux kernel (defined in default module)
    supportedFilesystems = {
      bcachefs = true;
      btrfs = true;
      zfs = lib.mkForce false; # FIX broken
    };
  };

  networking.wireless.enable = false;

  programs = {
    # TODO Helix with custom config as default editor
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
          email = "pro@guilhemfau.re";
          name = "Guilhem Fauré";
        };
      };
    };
  };

  environment = {
    shellAliases = {
      # TODO directly include them under /root/
      clone = "git clone https://gitlab.com/gfauredev/nixos-config.git"; # Easilly clone this repo
      clone-ssh = "git clone git@gitlab.com:gfauredev/nixos-config.git"; # Easilly clone this repo with SSH
    };
  };

  # FIXME no initial password when booted
  users.users.root.password = "password"; # Directly able to login via SSH
  # initialHashedPassword = lib.mkForce null;
  # isNormalUser = true;
  # extraGroups = [ "wheel" ];

  services = {
    openssh = {
      enable = true; # Enable the OpenSSH daemon
      settings.PermitRootLogin = "yes"; # Easily login as root via SSH
      settings.PasswordAuthentication = true;
    };
    # nfs.server.enable = lib.mkDefault true;
  };
}
