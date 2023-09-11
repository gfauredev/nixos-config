# Help: configuration.nix(5) man page and NixOS manual: ’nixos-help’
{ config, pkgs, lib, ... }:
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix # Hardware scan result
    ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      # substituters = [
      #   "https://cachix.org"
      # ];
      # trusted-public-keys = [
      # ];
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  system = {
    autoUpgrade.enable = lib.mkDefault true; # Enable auto upgrades
    autoUpgrade.allowReboot = lib.mkDefault false; # Auto reboot if up
    stateVersion = lib.mkDefault "22.05"; # https://nixos.org/nixos/options.html
  };

  boot = {
    loader.systemd-boot.enable = lib.mkDefault true; # Use the light EFI boot loader
    loader.efi.canTouchEfiVariables = lib.mkDefault true; # Don’t touch if buggy UEFI
    # kernelPackages = lib.mkDefault pkgs.linuxPackages_latest; # Latest linux kernel
  };

  security.apparmor.enable = true;

  console.font = "Lat2-Terminus16";
  console.keyMap = "fr-bepo";

  time = {
    timeZone = "Europe/Paris"; # Set time zone
    hardwareClockInLocalTime = true; # Compatibility with Windows
  };

  i18n = {
    # Locales internatinalization properties
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
    ];
    defaultLocale = "en_US.UTF-8"; # Set localization settings
    extraLocaleSettings = {
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_MEASUREMENTS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_COLLATE = "C";
    };
  };

  users.mutableUsers = lib.mkDefault false;

  networking = {
    # nameservers = [
    #   # "193.110.81.9" #zero.dns0.eu
    #   # "2a0f:fc80::9" #zero.dns0.eu
    #   # "185.253.5.9" #zero.dns0.eu
    #   # "2a0f:fc81::9" #zero.dns0.eu
    #   "193.110.81.0" #dns0.eu
    #   "2a0f:fc80::" #dns0.eu
    #   "185.253.5.0" #dns0.eu
    #   "2a0f:fc81::" #dns0.eu
    # ];
    # resolvconf = {
    #   enable = lib.mkDefault false;
    #   # useLocalResolver = false;
    # };
    # networkmanager = {
    #   enable = lib.mkDefault true;
    #   dns = lib.mkDefault "none";
    #   insertNameservers = lib.mkDefault [
    #     # "193.110.81.9" #zero.dns0.eu
    #     # "2a0f:fc80::9" #zero.dns0.eu
    #     # "185.253.5.9" #zero.dns0.eu
    #     # "2a0f:fc81::9" #zero.dns0.eu
    #     "193.110.81.0" #dns0.eu
    #     "2a0f:fc80::" #dns0.eu
    #     "185.253.5.0" #dns0.eu
    #     "2a0f:fc81::" #dns0.eu
    #   ];
    # };
    firewall.enable = lib.mkDefault true; # Enable firewall
  };

  programs = {
    # neovim = {
    #   enable = true;
    #   defaultEditor = true;
    #   viAlias = true;
    #   vimAlias = true;
    # };
    # git.enable = true;
  };

  environment.variables = {
    PATH = "$PATH:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/pnpm";
  };
}
