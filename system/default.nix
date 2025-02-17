{ lib, pkgs, config, ... }: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11" # GPU drivers
      "nvidia-settings" # GPU drivers
      "nvidia-persistenced" # GPU drivers
      "hp" # Printer drivers
      "steam" # Video games software
      "steam-original" # Video games software
      "steam-unwrapped" # Video games software
      "steam-run" # Video games software
    ];

  # sops = {
  #   defaultSopsFile = ../secret/default.yml;
  #   defaultSopsFormat = "yaml";
  #   age.keyFile = "/home/gf/.config/sops/age/keys.txt";
  #   secrets = {
  #     example_key = {
  #       mode = "0440"; # Allow group to read
  #       owner = config.users.users.root.name;
  #       group = config.users.users.gf.group;
  #       path = ""; # Get it from anywhere in config
  #       restartUnits = [ ];
  #     };
  #   };
  # };

  nix = {
    # add each flake input as a registry
    # To make nix3 commands consistent with flake
    # registry = lib.mapAttrs (_: value: { flake = value; }) inputs; TEST relevance
    # add inputs to the system's legacy channels
    # Making legacy nix commands consistent as well
    # nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") TEST relevance
    #   config.nix.registry; TEST relevance

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
    kernel.sysctl = {
      "kernel.sysrq" = 212;
      # "vm.swappiness" = 50; # Reduce memory swap to disk (no swap partition anyway)
    };
    kernelPackages = lib.mkOverride 1001
      pkgs.linuxPackages_latest; # Latest Linux kernel by default
    kernelParams = [
      "threadirqs" # Force threading interrupts
    ];
    swraid.enable = lib.mkDefault false; # FIX for some issue with mdadm
    supportedFilesystems = [ "bcachefs" ]; # Add support for bcachefs
    # postBootCommands = '' # TEST relevance, used by musnix
    #   ${pkgs.pciutils}/bin/setpci -v -d *:* latency_timer=b0
    #   ${pkgs.pciutils}/bin/setpci -v -s ${cfg.soundcardPciId} latency_timer=ff
    # '';
  };

  fonts = {
    enableDefaultPackages = true; # Standard fonts
    packages = with pkgs; [
      #################### Serif ####################
      libre-baskerville # Great, stylish serif
      vollkorn # Great serif font
      # merriweather # Serif readable on low res screens
      # gelasio # Serif Georgia replacement
      # lmodern # Classic serif
      # noto-fonts-cjk-serif
      #################### Sans ####################
      fira-go # Great sans with icons
      nacelle # Helvetica equivalent
      inter # Interesting sans font
      carlito # Calibri equivalent
      # merriweather-sans # Sans font readable on low res
      # libre-franklin
      noto-fonts-cjk-sans # Chinese, Japanese, Korean sans
      #################### Mono ####################
      nerd-fonts.fira-code
      # nerd-fonts.fira-mono
      nerd-fonts.iosevka
      nerd-fonts.hack
      #################### Packages ####################
      liberation_ttf # ≃ Times New Roman, Arial, Courier New equivalents
      # noto-fonts # Google well internationalized fonts
      #################### Symbols ####################
      noto-fonts-emoji # Emojies
      # fira-code-symbols # Great icons
      # emojione # Emojies
      # lmmath # Classic font with math support
      # font-awesome # Thousands of icons
    ];
  };
  console = {
    keyMap = lib.mkDefault "fr-bepo";
    # font = "Lat2-Terminus16";
    # useXkbConfig = lib.mkDefault true;
  };

  time = {
    timeZone = lib.mkDefault "Europe/Paris";
    hardwareClockInLocalTime =
      lib.mkDefault false; # True for compatibility with Windows
  };

  networking = let
    dns0.normal = [ # Modern European public DNS
      "2a0f:fc80::#dns0.eu" # IPv6
      "193.110.81.0#dns0.eu" # IPv4
      "2a0f:fc81::#dns0.eu" # IPv6
      "185.253.5.0#dns0.eu" # IPv4
    ];
    dns0.hard = [ # Hardened modern European public DNS
      "2a0f:fc80::9#zero.dns0.eu" # IPv6
      "193.110.81.9#zero.dns0.eu" # IPv4
      "2a0f:fc81::9#zero.dns0.eu" # IPv6
      "185.253.5.9#zero.dns0.eu" # IPv4
    ];
    quad9.normal = [ # Public DNS
      "2620:fe::fe#dns.quad9.net"
      "9.9.9.9#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
    ];
    quad9.hard = [ # Hardened public DNS
      "2620:fe::11#dns11.quad9.net"
      "9.9.9.11#dns11.quad9.net"
      "2620:fe::fe:11#dns11.quad9.net"
      "149.112.112.11#dns11.quad9.net"
    ];
    fdn.normal = [ # Non-profit public DNS
      "2001:910:800::12#ns0.fdn.fr"
      "80.67.169.12#ns0.fdn.fr"
      "2001:910:800::40#ns1.fdn.fr"
      "80.67.169.40#ns1.fdn.fr"
    ];
    cloudflare.normal = [ # Quick public DNS
      "2606:4700:4700::1111#one.one.one.one"
      "1.1.1.1#one.one.one.one"
      "2606:4700:4700::1001#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
  in {
    firewall.enable = lib.mkDefault true;
    wireguard.enable = lib.mkDefault true;
    networkmanager = {
      # See: https://developer.gnome.org/NetworkManager/stable/NetworkManager.html
      enable = lib.mkDefault true;
      insertNameservers = config.networking.nameservers; # FIX for below
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
    nameservers = dns0.normal; # Doesn’t seem effective, FIX above
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
      enable = lib.mkDefault true; # Do not enable the OpenSSH daemon by default
      settings = {
        PermitRootLogin = lib.mkDefault "no";
        LogLevel = "VERBOSE"; # For fail2ban
        PasswordAuthentication = lib.mkDefault true;
      };
    };
    fail2ban.enable = lib.mkDefault true;
  };

  programs.openvpn3.enable = lib.mkDefault true;

  i18n = {
    supportedLocales = lib.mkDefault [ "en_GB.UTF-8/UTF-8" ];
    defaultLocale = lib.mkDefault "en_GB.UTF-8";
  };

  environment = {
    binsh = "${pkgs.dash}/bin/dash"; # Light POSIX shell
    systemPackages = with pkgs; [
      dash # Small & light POSIX shell for scripts
      lsof # list openned files
      zip # Compression
      unzip # Decompression
      _7zz # Compression / Decompression (7zip)
      # p7zip # Compression / Decompression compatible with 7zip
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
    ];
  };
}
