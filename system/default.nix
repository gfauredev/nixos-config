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
    # TODO ensure DoH, DoT or better ODoH is used
    # See https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
    dns0.open = [ # Unfiltered modern European public DNS
      "2a0f:fc80::ffff" # open.dns0.eu" # IPv6
      "193.110.81.254" # open.dns0.eu" # IPv4
      "2a0f:fc81::ffff" # open.dns0.eu" # IPv6
      "185.253.5.254" # open.dns0.eu" # IPv4
    ];
    dns0.normal = [ # Modern European public DNS
      "2a0f:fc80::" # dns0.eu" # IPv6
      "193.110.81.0" # dns0.eu" # IPv4
      "2a0f:fc81::" # dns0.eu" # IPv6
      "185.253.5.0" # dns0.eu" # IPv4
    ];
    dns0.hard = [ # Hardened modern European public DNS
      "2a0f:fc80::9" # zero.dns0.eu" # IPv6
      "193.110.81.9" # zero.dns0.eu" # IPv4
      "2a0f:fc81::9" # zero.dns0.eu" # IPv6
      "185.253.5.9" # zero.dns0.eu" # IPv4
    ];
    fdn.open = [ # Non-profit public DNS
      "2001:910:800::12" # ns0.fdn.fr" # IPv6
      "80.67.169.12" # ns0.fdn.fr" # IPv4
      "2001:910:800::40" # ns1.fdn.fr" # IPv6
      "80.67.169.40" # ns1.fdn.fr" # IPv4
    ];
    cloudflare.open = [ # Quick public DNS
      "2606:4700:4700::1111" # one.one.one.one" # IPv6
      "1.1.1.1" # one.one.one.one" # IPv4
      "2606:4700:4700::1001" # one.one.one.one" # IPv6
      "1.0.0.1" # one.one.one.one" # IPv4
    ];
    quad9.open = [ # Public DNS
      "2620:fe::10" # dns.quad9.net" # IPv6
      "9.9.9.10" # dns.quad9.net" # IPv4
      "2620:fe::fe:10" # dns.quad9.net" # IPv6
      "149.112.112.10" # dns.quad9.net" # IPv4
    ];
    quad9.normal = [ # Public DNS
      "2620:fe::fe" # dns.quad9.net" # IPv6
      "9.9.9.9" # dns.quad9.net" # IPv4
      "2620:fe::9" # dns.quad9.net" # IPv6
      "149.112.112.112" # dns.quad9.net" # IPv4
    ];
    quad9.hard = [ # Hardened public DNS
      "2620:fe::11" # dns11.quad9.net" # IPv6
      "9.9.9.11" # dns11.quad9.net" # IPv4
      "2620:fe::fe:11" # dns11.quad9.net" # IPv6
      "149.112.112.11" # dns11.quad9.net" # IPv4
    ];
    mullvad.open = [ # Privacy oriented public DNS
      "2a07:e340::2" # dns.mullvad.net # IPv6
      "194.242.2.2" # dns.mullvad.net # IPv4
    ];
    mullvad.hard = [ # Privacy and security oriented public DNS
      "2a07:e340::4" # base.dns.mullvad.net # IPv6
      "194.242.2.4" # base.dns.mullvad.net # IPv4
    ];
    shaft.open = [
      "2001:bc8:2c86:853::853" # dns.shaftinc.fr # IPv6
    ];
  in {
    nameservers = dns0.open ++ cloudflare.open ++ quad9.open ++ fdn.open
      ++ mullvad.hard ++ shaft.open;
    firewall.enable = lib.mkDefault true;
    wireguard.enable = lib.mkDefault true;
    networkmanager = {
      # See: https://developer.gnome.org/NetworkManager/stable/NetworkManager.html
      enable = lib.mkDefault true;
      # insertNameservers = config.networking.nameservers;
      dns = "none"; # Static name servers, we don’t want DHCP ones
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
    # See https://wiki.nixos.org/wiki/Encrypted_DNS
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        sources.public-resolvers = {
          urls = [
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          ];
          cache_file = "public-resolvers.md";
          # See https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
          minisign_key =
            "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
        ipv4_servers = true;
        ipv6_servers = true;
        dnscrypt_servers = true;
        doh_servers = true;
        odoh_servers = true;
        require_dnssec = true;
        require_nolog = true;
        require_nofilter = true;
      };
    };
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
