{ lib, config, pkgs, ... }: {
  imports = [
    # <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel.nix>
    # <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    # <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  # nixpkgs.config.allowUnfree = true;
  # hardware.enableAllFirmware = true;

  # boot = {
  #   kernel.sysctl = { "kernel.sysrq" = 176; }; # Enable great SysRq magic keys
  # };

  console.keyMap = lib.mkDefault "fr-bepo"; # My favorite keymap

  networking = {
    wireless.enable = false;
    networkmanager = {
      enable = true;
    };
  };

  # services = {
  #   openssh = {
  #     enable = true; # Enable the OpenSSH daemon
  #     settings = {
  #       PermitRootLogin = "yes"; # We want to easily configure headlessly
  #       PasswordAuthentication = true;
  #     };
  #   };
  #   nfs.server.enable = lib.mkDefault true;
  # };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    git = {
      enable = true;
      userName = "Guilhem Fauré";
      userEmail = "pro@gfaure.eu";
    };
  };

  environment = {
    shellAliases = {
      clone = "git clone https://gitlab.com/gfauredev/nixos-config.git"; # Easilly clone this repo
      clones = "git clone git@gitlab.com:gfauredev/nixos-config.git"; # Easilly clone this repo with SSH
    };
    # systemPackages = with pkgs; [
    #   util-linux # System utilities
    #   xh # HTTP client
    #   lsof # list openned files
    #   zip # Compression
    #   unzip # Decompression
    #   p7zip # Compression / Decompression
    #   gzip # Compression / Decompression
    #   bzip2 # Compression / Decompression
    #   acpi # Information about hardware
    #   usbutils # lsusb
    #   pciutils # lspci
    #   lm_sensors # get temps
    #   wakelan # send magick packet to wake WoL devices
    # ];
  };

  # users.users.nixos = {
  #   password = "password"; # Directly able to login via SSH
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ];
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  # system.stateVersion = "23.11";
}
