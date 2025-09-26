{ pkgs, lib, ... }: # Configuration for actual machines, not VMs or live ISOs
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      # "ciscoPacketTracer8" # Network simulation
      # "deconz" # Manage ZigBee/Matter networks
      "hp" # Printer drivers
      # "nvidia-x11" # GPU drivers
      # "nvidia-settings" # GPU drivers
      # "nvidia-persistenced" # GPU drivers
      # "steam" # Video games software
      # "steam-original" # Video games software
      # "steam-unwrapped" # Video games software
      # "steam-run" # Video games software
      "ventoy" # Multiboot USB
    ];

  nix = {
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 15d"; # +3";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      connect-timeout = 3; # Quickly go offline if substitute not reachable
      allowed-users = [ "@wheel" ]; # Restrict Nix to wheel
      max-jobs = lib.mkDefault 8; # Save some threads
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      ];
    };
  };

  boot = {
    loader.systemd-boot.enable = lib.mkDefault true; # Lightweight boot manager
    # loader.efi.canTouchEfiVariables = lib.mkDefault true; # Ok for proper UEFI
    kernelParams = [
      "threadirqs" # Process interrupts asynchronously to reduce latency
      "zswap.enabled=1" # Compressed RAM cache for swap pages
      "zswap.compressor=zstd" # Compression algorithm, use lz4 for more speed
      "zswap.max_pool_percent=20" # Zswap allowed RAM%
      "zswap.shrinker_enabled=1" # Shrink pool proactively on high memory demand
    ];
    loader.systemd-boot.configurationLimit = lib.mkDefault 6; # Limit prev confs
    consoleLogLevel = 0; # Don’t clutter screen at boot
  };

  security.apparmor.enable = lib.mkDefault true; # See https://search.nixos.org/options?channel=25.05&query=apparmor TODO configure

  users = {
    defaultUserShell = pkgs.dash; # Only allow dash shell, reduce attack surface
    mutableUsers = lib.mkDefault false;
  };

  services = {
    ntp.enable = lib.mkDefault true;
    dnscrypt-proxy2.enable = lib.mkDefault true; # See https://wiki.nixos.org/wiki/Encrypted_DNS TEST it
    usbguard.enable = true; # TODO config it
    dnscrypt-proxy2 = {
      settings = {
        sources.public-resolvers = {
          urls = [
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          ];
          cache_file = "public-resolvers.md";
          # See https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
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
}
