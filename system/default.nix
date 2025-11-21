{ lib, pkgs, ... }:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [ "https://nix-community.cachix.org" ]; # May have additional binaries cached
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
    ];
    max-jobs = lib.mkDefault 8; # Save some threads for rest of system
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
    swraid.enable = lib.mkDefault false; # FIX for some issue with mdadm
  };

  console.keyMap = "fr-bepo";

  time = {
    timeZone = lib.mkDefault "Europe/Paris";
    hardwareClockInLocalTime = lib.mkDefault false; # True for compatibility with Window$
  };

  networking =
    let
      # TODO ensure DoH, DoT or better ODoH is used
      # See https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      dns0.open = [
        # Unfiltered modern European public DNS
        "2a0f:fc80::ffff" # open.dns0.eu" # IPv6
        "193.110.81.254" # open.dns0.eu" # IPv4
        "2a0f:fc81::ffff" # open.dns0.eu" # IPv6
        "185.253.5.254" # open.dns0.eu" # IPv4
      ];
      dns0.normal = [
        # Modern European public DNS
        "2a0f:fc80::" # dns0.eu" # IPv6
        "193.110.81.0" # dns0.eu" # IPv4
        "2a0f:fc81::" # dns0.eu" # IPv6
        "185.253.5.0" # dns0.eu" # IPv4
      ];
      dns0.hard = [
        # Hardened modern European public DNS
        "2a0f:fc80::9" # zero.dns0.eu" # IPv6
        "193.110.81.9" # zero.dns0.eu" # IPv4
        "2a0f:fc81::9" # zero.dns0.eu" # IPv6
        "185.253.5.9" # zero.dns0.eu" # IPv4
      ];
      fdn.open = [
        # Non-profit public DNS
        "2001:910:800::12" # ns0.fdn.fr" # IPv6
        "80.67.169.12" # ns0.fdn.fr" # IPv4
        "2001:910:800::40" # ns1.fdn.fr" # IPv6
        "80.67.169.40" # ns1.fdn.fr" # IPv4
      ];
      cloudflare.open = [
        # Quick public DNS
        "2606:4700:4700::1111" # one.one.one.one" # IPv6
        "1.1.1.1" # one.one.one.one" # IPv4
        "2606:4700:4700::1001" # one.one.one.one" # IPv6
        "1.0.0.1" # one.one.one.one" # IPv4
      ];
      quad9.open = [
        # Public DNS
        "2620:fe::10" # dns.quad9.net" # IPv6
        "9.9.9.10" # dns.quad9.net" # IPv4
        "2620:fe::fe:10" # dns.quad9.net" # IPv6
        "149.112.112.10" # dns.quad9.net" # IPv4
      ];
      quad9.normal = [
        # Public DNS
        "2620:fe::fe" # dns.quad9.net" # IPv6
        "9.9.9.9" # dns.quad9.net" # IPv4
        "2620:fe::9" # dns.quad9.net" # IPv6
        "149.112.112.112" # dns.quad9.net" # IPv4
      ];
      quad9.hard = [
        # Hardened public DNS
        "2620:fe::11" # dns11.quad9.net" # IPv6
        "9.9.9.11" # dns11.quad9.net" # IPv4
        "2620:fe::fe:11" # dns11.quad9.net" # IPv6
        "149.112.112.11" # dns11.quad9.net" # IPv4
      ];
      mullvad.open = [
        # Privacy oriented public DNS
        "2a07:e340::2" # dns.mullvad.net # IPv6
        "194.242.2.2" # dns.mullvad.net # IPv4
      ];
      mullvad.hard = [
        # Privacy and security oriented public DNS
        "2a07:e340::4" # base.dns.mullvad.net # IPv6
        "194.242.2.4" # base.dns.mullvad.net # IPv4
      ];
      shaft.open = [
        "2001:bc8:2c86:853::853" # dns.shaftinc.fr # IPv6
      ];
    in
    {
      nameservers = dns0.open ++ cloudflare.open ++ quad9.open ++ fdn.open ++ mullvad.hard ++ shaft.open;
      wireguard.enable = lib.mkDefault true;
      networkmanager = {
        # See: https://developer.gnome.org/NetworkManager/stable/NetworkManager.html
        enable = lib.mkDefault true;
        # insertNameservers = config.networking.nameservers;
        # dns = "none"; # Static name servers, we don’t want DHCP ones
        dispatcherScripts = [
          {
            source = pkgs.writeShellScript "09-timezone" ''
              case "$2" in
              # connectivity-change) # Prevent change with VPNs
              up)
                timedatectl set-timezone "$(curl --fail https://ipapi.co/timezone)"
                ;;
              esac
            '';
            type = "basic";
          }
        ];
      };
      firewall = {
        allowedTCPPorts = [
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
    neovim.enable = lib.mkDefault false; # Use helix instead
    openvpn3.enable = lib.mkDefault true;
    amnezia-vpn.enable = lib.mkDefault true; # DPI resistant WireGuard
    neovim = {
      defaultEditor = lib.mkDefault true;
      viAlias = true;
      vimAlias = true;
    };
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
      duf # Global disk usage
      du-dust # Detailed disk usage of a directory
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
      wireguard-tools # CLI for WireGuard
      xh # User-friendly HTTP client similar to HTTPie/cURL
      gping # Ping with a graph
      tcpdump # Dump network packets
      dhcpdump # DHCP debugging
      inetutils # Things like FTP command
      nmap # Scan ports
      dogdns # CLI DNS Client
      # dig # CLI DNS Client
      tshark # Wireshark CLI
      termshark # Wireshark TUI
      kismet # Wireless network sniffer
      thc-hydra # Pentesting tool
      age # Modern encryption
      ssh-to-age # Converter between SSH keys and age
      lynis # System security auditing TEST me
      vulnix # NixOS vulnerability scanner TEST me
      # Storage
      zip # Universal compression
      unzip # Universal decompression
      _7zz # Compression / Decompression (7zip)
      gzip # Compression / Decompression
      bzip2 # Compression / Decompression
      exfat # USB sticks filesystem
      ntfs3g # Window$s filesystem
    ];
  };
}
