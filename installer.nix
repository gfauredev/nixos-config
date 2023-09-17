{ inputs, lib, config, pkgs, ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    # <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  boot = {
    kernel.sysctl = { "kernel.sysrq" = 176; }; # Enable great SysRq magic keys
  };

  console.font = "Lat2-Terminus16";
  console.keyMap = lib.mkDefault "fr-bepo"; # My favorite keymap

  time = {
    timeZone = lib.mkDefault "Europe/Paris";
    hardwareClockInLocalTime = lib.mkDefault false; # True for compatibility with Windows
  };

  networking = {
    wireless.enable = false;
    # useDHCP = true;
    networkmanager = {
      enable = true;
    };
  };

  services = {
    openssh = {
      enable = true; # Enable the OpenSSH daemon
      settings = {
        PermitRootLogin = "yes"; # We want to easily configure headlessly
        PasswordAuthentication = true;
      };
    };
    nfs.server.enable = lib.mkDefault true;
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    git.enable = true;
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      autosuggestions = {
        enable = true;
      };
    };
  };

  i18n = {
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      # "fr_FR.UTF-8/UTF-8"
    ];
    defaultLocale = lib.mkDefault "en_US.UTF-8";
  };

  environment = {
    binsh = "${pkgs.dash}/bin/dash"; # Light POSIX shell
    shells = with pkgs; [ zsh ];
    shellAliases = {
      clone = "git clone https://gitlab.com/gfauredev/nixos-config.git"; # Easilly clone this repo
    };
    systemPackages = with pkgs; [
      dash # Small & light POSIX shell for scripts
      util-linux # System utilities
      xh # HTTP client
      lsof # list openned files
      zip # Compression
      unzip # Decompression
      p7zip # Compression / Decompression
      gzip # Compression / Decompression
      bzip2 # Compression / Decompression
      acpi # Information about hardware
      usbutils # lsusb
      pciutils # lspci
      lm_sensors # get temps
      wakelan # send magick packet to wake WoL devices
      # curl # HTTP client
    ];
  };

  users.users.nixos = {
    password = "password"; # Directly able to login via SSH
    shell = pkgs.zsh;
  };
}
