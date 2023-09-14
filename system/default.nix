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

  console.font = "Lat2-Terminus16";
  console.keyMap = "fr-bepo";

  time = {
    timeZone = lib.mkDefault "Europe/Paris";
    hardwareClockInLocalTime = lib.mkDefault false; # True for compatibility with Windows
  };

  networking.firewall.enable = lib.mkDefault true;

  i18n = {
    supportedLocales = lib.mkDefault [ "en_US.UTF-8/UTF-8" ];
    defaultLocale = lib.mkDefault "en_US.UTF-8";
  };
}
