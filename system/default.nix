{
  config,
  lib,
  pkgs,
  ...
}:
let
  local = [
    "127.0.0.1" # Local IPv4 (Blocky)
    "::1" # Local IPv6 (Blocky)
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
  mullvad.doh.open = "dns.mullvad.net/dns-query"; # Port 443
  mullvad.dot.open = "dns.mullvad.net"; # Port 853
  mullvad.ip.hard = [
    "2a07:e340::4" # base.dns.mullvad.net # IPv6
    "194.242.2.4" # base.dns.mullvad.net # IPv4
  ];
  mullvad.doh.hard = "base.dns.mullvad.net/dns-query"; # Port 443
  mullvad.dot.hard = "base.dns.mullvad.net"; # Port 853
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
  # Blocky upstream formats: [net:]host[:port][/path], accept a string or a list
  doh = hosts: map (host: "https://${host}") (lib.toList hosts); # Port 443
  dot = hosts: map (host: "tcp-tls:${host}") (lib.toList hosts); # Port 853
  plain = map (ip: if lib.hasInfix ":" ip then "tcp+udp:[${ip}]" else "tcp+udp:${ip}"); # Port 53
  dnscryptProxy = "127.0.0.1:5300"; # DNSCrypt Proxy listen address, if enabled
  # DNS tiers tried in order
  dns.encrypted =
    lib.optional config.services.dnscrypt-proxy.enable "tcp+udp:${dnscryptProxy}" # DNSCrypt, ODoH
    ++ doh dns4eu.doh.hard
    ++ doh mullvad.doh.hard
    ++ doh cloudflare.doh.open;
  dns.unencrypted = plain (lib.take 2 dns4eu.ip.open) ++ plain cloudflare.ip.open;
  # systemd-resolved stub, which only knows per-link DNS (DHCP/AP provided, VPN pushed)
  dns.provided = [ "tcp+udp:127.0.0.53" ];
in
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

  networking = {
    nameservers = local; # Blocky, see services.blocky
    wireguard.enable = lib.mkDefault true;
    networkmanager = {
      enable = lib.mkDefault true;
      # Give DHCP/AP provided DNS to systemd-resolved per link, Blocky only uses it as last resort
      dns = lib.mkForce "systemd-resolved";
      plugins = [ pkgs.networkmanager-openvpn ];
      ethernet.macAddress = "random";
      wifi.macAddress = "stable-ssid";
    };
    nftables.enable = lib.mkDefault true;
  };

  # Local DNS resolver: encrypted → unencrypted → AP provided (captive portals, filtering LANs…)
  services.blocky = {
    enable = lib.mkDefault true;
    settings = {
      ports.dns = map (ip: if lib.hasInfix ":" ip then "[${ip}]:53" else "${ip}:53") local;
      upstreams = {
        strategy = "strict"; # In order, next one only on error, timeout or SERVFAIL
        timeout = "5s"; # Try hard before falling back unencrypted
        init.strategy = "fast"; # Don’t block or fail boot when offline
        groups.default = dns.encrypted ++ dns.unencrypted ++ dns.provided;
      };
      # Resolve DoH/DoT upstreams hostnames, with pinned IPs (never the system resolver: loop)
      bootstrapDns = [
        {
          upstream = builtins.head (doh quad9.doh.hard);
          ips = quad9.ip.hard;
        }
        {
          upstream = builtins.head (dot dns4eu.dot.hard);
          ips = dns4eu.ip.hard;
        }
      ];
      caching = {
        maxTime = "5m"; # Short, don’t keep captive portal answers for long
        cacheTimeNegative = "1m"; # Short, don’t keep captive portal NXDOMAINs for long
        prefetching = true; # Refresh popular names in the background
      };
      queryLog.type = "none"; # Don’t log queries
      log.level = "warn";
    };
  };

  # Preferred encrypted upstream (DNSCrypt, ODoH…) on machines enabling it, behind Blocky
  services.dnscrypt-proxy.settings.listen_addresses = [ dnscryptProxy ];

  # Only knows per-link DNS (DHCP/AP provided, VPN pushed), Blocky’s last resort upstream
  services.resolved = {
    enable = lib.mkDefault true; # Also enabled by amnezia-vpn
    settings.Resolve = {
      DNS = lib.mkForce [ ]; # No global DNS, would loop through Blocky
      FallbackDNS = [ ]; # No built-in Google/Cloudflare fallback
      DNSSEC = false; # Breaks with captive portals and lying DNS
      LLMNR = false; # Don’t leak names on the LAN
    };
  };

  # Everything goes through Blocky, never directly to resolved (thus AP provided DNS)
  environment.etc."resolv.conf" = lib.mkIf config.services.blocky.enable {
    source = lib.mkForce (
      pkgs.writeText "resolv.conf" ''
        ${lib.concatMapStrings (ip: "nameserver ${ip}\n") local}options edns0
      ''
    );
  };
  # Remove systemd-resolved NSS module ("resolve"), which would bypass Blocky
  system.nssDatabases.hosts = lib.mkIf config.services.blocky.enable (
    lib.mkForce (
      [ "mymachines" ]
      ++ lib.optional config.services.avahi.nssmdns4 "mdns4_minimal [NOTFOUND=return]"
      ++ [
        "files"
        "myhostname"
        "dns"
      ]
      ++ lib.optional config.services.avahi.nssmdns4 "mdns4"
    )
  );

  security.sudo.enable = lib.mkDefault true;

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
      # Shell utilities
      helix # Post-modern modal text editor
      dash # Only login and script shell
      ov # Modern pager
      hexyl # hex viewer
      sd # Intuitive find & replace
      grex # Regex generator from test cases
      coreutils-full # Additional Unix utilities
      moreutils # Additional Unix utilities
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
