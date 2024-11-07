{ inputs, lib, config, pkgs, stablepkgs, ... }: {
  nix = {
    # add each flake input as a registry
    # To make nix3 commands consistent with flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    # add inputs to the system's legacy channels
    # Making legacy nix commands consistent as well
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

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
    # Enable SysRq keys (reboot/off:128, kill:64, sync:16, kbdControl: 4)
    kernel.sysctl = { "kernel.sysrq" = 212; };
    kernelPackages = lib.mkOverride 1001
      pkgs.linuxPackages_latest; # Latest Linux kernel by default
    swraid.enable = lib.mkDefault false; # FIX for some issue with mdadm
    supportedFilesystems = [ "bcachefs" ]; # Add support for bcachefs
  };

  console.font = "Lat2-Terminus16";
  console.keyMap = lib.mkDefault "fr-bepo";

  time = {
    timeZone = lib.mkDefault "Europe/Paris";
    hardwareClockInLocalTime =
      lib.mkDefault false; # True for compatibility with Windows
  };

  networking = let
    dns = [
      #dns0.eu
      "193.110.81.0"
      "2a0f:fc80::"
      "185.253.5.0"
      "2a0f:fc81::"
    ];
  in {
    firewall.enable = lib.mkDefault true;
    wireguard.enable = lib.mkDefault true;
    networkmanager = {
      enable = lib.mkDefault true;
      appendNameservers = dns;
      # see https://developer.gnome.org/NetworkManager/stable/NetworkManager.html
      dispatcherScripts = [{
        source = pkgs.writeShellScript "09-timezone" ''
          case "$2" in
          # connectivity-change) # Prevent change with VPNs
          up)
            timedatectl set-timezone "$(curl --fail https://ipapi.co/timezone)"
            ;;
          esac
        '';
        type = "basic";
      }];
    };
    nameservers = dns;
  };

  hardware = {
    bluetooth = {
      enable = lib.mkDefault true;
      powerOnBoot = lib.mkDefault true;
    };
  };

  security = {
    sudo.enable = lib.mkDefault true;
    # apparmor.enable = lib.mkDefault true; # TEST pertinence
  };

  users.mutableUsers = lib.mkDefault true; # Set passwords imperatively

  services = {
    ntp.enable = lib.mkDefault true;
    nfs.server.enable = lib.mkDefault true;
    openssh = {
      enable =
        lib.mkDefault false; # Do not enable the OpenSSH daemon by default
      settings = {
        PermitRootLogin = lib.mkDefault "no";
        LogLevel = "VERBOSE"; # For fail2ban
        PasswordAuthentication = lib.mkDefault true;
      };
    };
    fail2ban.enable = lib.mkDefault true;
  };

  programs.openvpn3.enable = lib.mkDefault true;
  programs.openvpn3.package = stablepkgs.openvpn3; # TODO remove

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
      # p7zip # Compression / Decompression compatible with 7zip
      _7zz # Compression / Decompression (7zip)
      # (_7zz.override { useUasm = true; }) # FIXME to remove when PR 353272 merged
      gzip # Compression / Decompression
      bzip2 # Compression / Decompression
      acpi # Information about hardware
      usbutils # lsusb
      pciutils # lspci
      lm_sensors # get temps
      wakelan # send magick packet to wake WoL devices
      age # Modern encryption
      sysstat # Monitoring CLI tools
      modemmanager # Mobile broadband
      # openvpn # Largely used VPN
      # inputs.agenix.packages.x86_64-linux.default
      # sops # Nix secret management
    ];
  };
}
