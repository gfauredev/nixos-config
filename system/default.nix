{ inputs, lib, config, pkgs, ... }: {
  imports = [
    /etc/nixos/hardware-configuration.nix # Hardware specific conf
  ];

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

  # security.apparmor.enable = true; # TEST relevance

  users.mutableUsers = lib.mkDefault true; # Set passwords imperatively

  # programs = { # TEST relevance
  #   neovim = {
  #     enable = true;
  #     defaultEditor = true;
  #     viAlias = true;
  #     vimAlias = true;
  #   };
  #   git.enable = true;
  # };

  i18n = {
    supportedLocales = lib.mkDefault [ "en_US.UTF-8/UTF-8" ];
    defaultLocale = lib.mkDefault "en_US.UTF-8";
  };
}
