{ lib, pkgs, ... }:
{
  imports = [
    ./options.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
      # "ca-derivations"
    ];
    trusted-substituters = [
      "https://cache.nix-ci.com"
      "https://gfauredev.cachix.org"
    ];
    # substituters = [ # Default: https://cache.nixos.org ];
    trusted-public-keys = [
      "nix-ci:g3xV5BDTLtIBZr/A00IU1x0EtKKlb7YLgBN2SgYgM6A="
      "gfauredev.cachix.org-1:mGOZ5I0bDVatgwLhbuTasIiWpVjgCyMFjfIZEPjmQfM="
      # "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" # Always added
      # "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
    ];
    max-jobs = lib.mkDefault 4; # Never start more than 16 processes
    cores = lib.mkDefault 4; # Never start more than 16 processes
    narinfo-cache-negative-ttl = 60; # Check caches more frequently
    min-free = "4G";
    max-free = "16G";
    allowed-users = [
      "@nix"
      "@wheel"
    ];
    trusted-users = [ ]; # No trusted users (root always)
    download-buffer-size = 268435456; # 256MiB, increased to reduce build times
    fallback = true; # Build from source if a binary substitute fails
    connect-timeout = 3; # Quickly go offline if substitute not reachable
    stalled-download-timeout = 10; # Quickly go offline if substitute not reachable
    download-attempts = 3; # Quickly go offline if substitute not reachable
  };

  boot = {
    # Enable SysRq keys (reboot/off:128, kill:64, sync:16, kbdControl: 4)
    kernel.sysctl = {
      "kernel.sysrq" = 212; # kbd control, read-only remount, nicing, power
      "vm.swappiness" = 50; # Reduce memory swap to disk TEST relevance
    };
    supportedFilesystems = [
      "bcachefs"
      "btrfs"
      # "zfs"
    ];
    extraModprobeConfig = ''
      options kvm ignore_msrs=1
    '';
    swraid.enable = lib.mkDefault false; # FIX for some issue with mdadm
    zfs.forceImportRoot = false; # FIX data loss risk
  };

  console.keyMap = "fr-bepo";

  users = {
    defaultUserShell = pkgs.dash; # Only allow dash shell, reduce attack surface
    mutableUsers = false;
    users = {
      root = {
        hashedPassword = null; # Disable root login
        password = null; # Disable root login
      };
      nixos = {
        hashedPassword = null; # FIXME Completely disable/remove this user if not useful
        password = null; # Completely disable/remove this user if not useful
        isSystemUser = true; # Completely disable/remove this user if not useful
        group = "nixos"; # Completely disable/remove this user if not useful
      };
    };
    groups.nixos = { }; # Completely disable/remove this user if not useful
  };

  time = {
    timeZone = lib.mkDefault "Europe/Paris";
    hardwareClockInLocalTime = lib.mkDefault false; # True for compatibility with Window$
  };

  networking =
    let
      # TODO ensure DoH, DoT or better ODoH is used
      # See https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      local = [
        "127.0.0.1" # Local IPv4 (DNSCrypt Proxy)
        "::1" # Local IPv6 (DNSCrypt Proxy)
      ];
      # Modern European public DNS
      dns4eu.ip.open = [
        "2a13:1001::86:54:11:100" # IPv6
        "86.54.11.100" # IPv4
        "2a13:1001::86:54:11:200" # IPv6
        "86.54.11.200" # IPv4
      ];
      dns4eu.doh.open = "unfiltered.joindns4.eu/dns-query";
      dns4eu.dot.open = "unfiltered.joindns4.eu";
      dns4eu.ip.normal = [
        "2a13:1001::86:54:11:1" # IPv6
        "86.54.11.1" # IPv4
        "2a13:1001::86:54:11:201" # IPv6
        "86.54.11.201" # IPv4
      ];
      dns4eu.doh.normal = "protective.joindns4.eu/dns-query";
      dns4eu.dot.normal = "protective.joindns4.eu";
      dns4eu.ip.hard = [
        "2a13:1001::86:54:11:13" # IPv6
        "86.54.11.13" # IPv4
        "2a13:1001::86:54:11:213" # IPv6
        "86.54.11.213" # IPv4
      ];
      dns4eu.doh.hard = "noads.joindns4.eu/dns-query";
      dns4eu.dot.hard = "noads.joindns4.eu";
      # French nonprofit public DNS
      fdn.ip.open = [
        "2001:910:800::12" # ns0.fdn.fr" # IPv6
        "80.67.169.12" # ns0.fdn.fr" # IPv4
        "2001:910:800::40" # ns1.fdn.fr" # IPv6
        "80.67.169.40" # ns1.fdn.fr" # IPv4
      ];
      fdn.doh.open = [
        "ns0.fdn.fr/dns-query"
        "ns1.fdn.fr/dns-query"
      ];
      fdn.dot.open = [
        "ns0.fdn.fr" # Port TCP/853
        "ns1.fdn.fr" # Port TCP/853
      ];
      # Privacy oriented Sweden public DNS
      mullvad.ip.open = [
        "2a07:e340::2" # dns.mullvad.net # IPv6
        "194.242.2.2" # dns.mullvad.net # IPv4
      ];
      mullvad.doh.open = "dns.mullvad.net"; # Port 443
      mullvad.dot.open = mullvad.doh.open; # Port 853
      mullvad.ip.hard = [
        "2a07:e340::4" # base.dns.mullvad.net # IPv6
        "194.242.2.4" # base.dns.mullvad.net # IPv4
      ];
      mullvad.doh.hard = "base.dns.mullvad.net"; # Port 443
      mullvad.dot.hard = mullvad.doh.hard; # Port 853
      # Independent DNS
      shaft.ip.open = [
        "2001:bc8:2c86:853::853" # dns.shaftinc.fr # IPv6
      ];
      # Fast American public DNS
      cloudflare.ip.open = [
        "2606:4700:4700::1111" # one.one.one.one" # IPv6
        "1.1.1.1" # one.one.one.one" # IPv4
        "2606:4700:4700::1001" # one.one.one.one" # IPv6
        "1.0.0.1" # one.one.one.one" # IPv4
      ];
      cloudflare.doh.open = [
        "one.one.one.one/dns-query" # Port 443
        "cloudflare-dns.com/dns-query" # Port 443
      ];
      cloudflare.dot.open = [
        "one.one.one.one" # Port 853
        "cloudflare-dns.com" # Port 853
      ];
      # Swiss nonprofit public DNS
      quad9.ip.open = [
        "2620:fe::10" # dns.quad9.net" # IPv6
        "9.9.9.10" # dns.quad9.net" # IPv4
        "2620:fe::fe:10" # dns.quad9.net" # IPv6
        "149.112.112.10" # dns.quad9.net" # IPv4
      ];
      quad9.doh.open = "dns10.quad9.net/dns-query";
      quad9.dot.open = "dns10.quad9.net";
      quad9.ip.normal = [
        "2620:fe::fe" # dns.quad9.net" # IPv6
        "9.9.9.9" # dns.quad9.net" # IPv4
        "2620:fe::9" # dns.quad9.net" # IPv6
        "149.112.112.112" # dns.quad9.net" # IPv4
      ];
      quad9.doh.normal = "dns.quad9.net/dns-query";
      quad9.dot.normal = "dns.quad9.net";
      quad9.ip.hard = [
        "2620:fe::11" # dns11.quad9.net" # IPv6
        "9.9.9.11" # dns11.quad9.net" # IPv4
        "2620:fe::fe:11" # dns11.quad9.net" # IPv6
        "149.112.112.11" # dns11.quad9.net" # IPv4
      ];
      quad9.doh.hard = "dns11.quad9.net/dns-query";
      quad9.dot.hard = "dns11.quad9.net";
    in
    {
      nameservers =
        local
        ++ dns4eu.ip.hard
        ++ mullvad.ip.hard
        ++ fdn.ip.hard
        ++ cloudflare.ip.hard
        ++ shaft.ip.open
        ++ dns4eu.ip.open
        ++ mullvad.ip.open
        ++ fdn.ip.open
        ++ cloudflare.ip.open
        ++ quad9.ip.hard;
      wireguard.enable = lib.mkDefault true;
      networkmanager = {
        enable = lib.mkDefault true;
        dns = lib.mkForce "none"; # Don’t care about lying/spying DHCP provided DNS servers
        plugins = [ pkgs.networkmanager-openvpn ];
        ethernet.macAddress = "random";
        wifi.macAddress = "stable-ssid";
      };
      nftables.enable = lib.mkDefault true; # TEST If don’t break things
      firewall = {
        allowedTCPPorts = [
          80 # Self hosted HTTP app
          443 # Self hosted HTTPS app
          # 22000 # Syncthing
          2049 # Vagrant
        ];
        allowedUDPPorts = [
          # 22000 # Syncthing
          # 21027 # Syncthing
          2049 # Vagrant
        ];
      };
    };

  services.syncthing.openDefaultPorts = lib.mkForce true; # TEST if sufficient

  security.sudo.enable = lib.mkDefault true;
  # security.sudo-rs.enable = lib.mkDefault true; # To TEST

  programs = {
    git.enable = lib.mkForce true; # MANDATORY
    neovim.enable = lib.mkDefault false; # Helix instead
    openvpn3.enable = lib.mkDefault true;
    amnezia-vpn.enable = lib.mkDefault true; # DPI resistant WireGuard
    git = {
      lfs.enable = true;
      config.init.defaultBranch = "main";
    };
  };

  environment = {
    shells = with pkgs; [ dash ]; # Only allowed login shell
    binsh = "${pkgs.dash}/bin/dash"; # Light POSIX shell
    defaultPackages = lib.mkForce [ ]; # Remove default packages
    systemPackages = with pkgs; [
      man-pages # Documentation, maybe install only for users
      man-pages-posix # Documentation, maybe install only for users
      # navi # Cheat sheet for CLIs
      # Shell utilities
      helix # Post-modern modal text editor
      dash # Only login and script shell
      ov # Modern pager
      hexyl # hex viewer
      sd # Intuitive find & replace
      grex # Regex generator from test cases
      coreutils-full # Additional Unix utilities
      moreutils # Additional Unix utilities
      gitlab-shell # GitLab CLI
      gitmoji-cli # Use emojis in commit messages
      convmv # Converts filenames from one encoding to another
      cpulimit # Limit CPU usage of a command
      # Hardware & disks monitoring
      lm_sensors # get temps
      acpi # Information about hardware
      sysstat # Monitoring CLI tools
      nix-tree # Find Nix dependencies
      dysk # Global disk usage
      dust # Detailed disk usage of a directory
      bottom # Dashboard with hardware usage, processes…
      nix-du # Determine which gc-roots take space
      lsof # List opened files (remember, everything’s a file here)
      usbutils # lsusb command
      pciutils # lspci command
      # sbctl # Secure Boot key manager, used for installing with Lanzaboote
      # Remote control
      rsync # Copy through network & with superpowers
      browsh # 6ixel CLI web browser
      sshfs # Mount ssh remote
      wakelan # Send magic packet to wake WoL devices
      # Network monitoring & Encryption
      amneziawg-tools # CLI for Amnezia VPN
      xh # User-friendly HTTP client similar to HTTPie/cURL
      gping # Ping with a graph
      tcpdump # Dump network packets
      dhcpdump # DHCP debugging
      inetutils # Things like FTP command
      nmap # Scan ports
      doggo # CLI DNS Client
      # dig # CLI DNS Client
      tshark # Wireshark CLI
      termshark # Wireshark TUI
      kismet # Wireless network sniffer
      thc-hydra # Pentesting tool
      age # Modern encryption
      ssh-to-age # Converter between SSH keys and age
      socat # Multipurpose relay (like netcat but better)
      lynis # System security auditing TEST me
      vulnix # NixOS vulnerability scanner TEST me
      # wireguard-tools # CLI for WireGuard
      # FS
      exfat # USB sticks filesystem
      ntfs3g # Window$s filesystem
      squashfsTools
      # (De)Compression
      libarchive # Multiformat smart (de)compression utility
      gzip
      bzip2
      xz
      zstd
      lz4
      brotli
      # _7zz # UNFREE _7zz-rar installed in user homes
    ];
  };
}
