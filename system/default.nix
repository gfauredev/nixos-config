{ inputs, lib, config, pkgs, ... }: {
  nix = {
    # add each flake input as a registry
    # To make nix3 commands consistent with flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    # add inputs to the system's legacy channels
    # Making legacy nix commands consistent as well
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  boot = {
    loader.systemd-boot.enable = lib.mkDefault true; # Light EFI boot loader
    loader.efi.canTouchEfiVariables = lib.mkDefault true; # Ok for proper UEFIs
    consoleLogLevel = 0; # Don’t clutter screen at boot
    kernel.sysctl = { "kernel.sysrq" = 176; }; # Enable great SysRq magic keys
    swraid.enable = false; # FIX for some issue with mdadm
  };

  console.font = "Lat2-Terminus16";
  console.keyMap = lib.mkDefault "fr-bepo";

  time = {
    timeZone = lib.mkDefault "Europe/Paris";
    hardwareClockInLocalTime = lib.mkDefault false; # True for compatibility with Windows
  };

  networking = {
    firewall.enable = lib.mkDefault true;
    wireguard.enable = lib.mkDefault true;
  };

  security = {
    sudo.enable = lib.mkDefault true;
    # polkit.enable = lib.mkDefault true; # TEST pertinence
    # apparmor.enable = lib.mkDefault true; # TEST pertinence
  };

  users.mutableUsers = lib.mkDefault true; # Set passwords imperatively

  services = {
    nfs.server.enable = lib.mkDefault true;
  };

  programs = {
    # neovim = { # TEST relevance
    #   enable = true;
    #   defaultEditor = true;
    #   viAlias = true;
    #   vimAlias = true;
    # };
    # git.enable = true; # TEST relevance
  };

  i18n = {
    supportedLocales = lib.mkDefault [ "en_US.UTF-8/UTF-8" ];
    defaultLocale = lib.mkDefault "en_US.UTF-8";
  };

  environment = {
    binsh = "${pkgs.dash}/bin/dash"; # Light POSIX shell
    systemPackages = with pkgs; [
      dash # Small & light POSIX shell for scripts
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
      # TEST relevance of below
      # bzip3
      # librsvg
      # openssl
      # age
      # libsecret
    ];
  };
}
