{ pkgs, lib, ... }: # Configuration for actual machines, not VMs or live ISOs
{
  imports = [ ./filesystem.nix ];

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 15d"; # +3";
  };
  nix.settings = {
    auto-optimise-store = true; # Auto hard-link identical files in Nix store
    connect-timeout = 3; # Quickly go offline if substitute not reachable
    stalled-download-timeout = 10; # Quickly go offline if substitute not reachable
    download-attempts = 3; # Quickly go offline if substitute not reachable
    allowed-users = [ "@wheel" ]; # Restrict Nix to wheel
    download-buffer-size = 268435456; # 256MiB, increased to reduce build times
  };
  # nixpkgs.config.allowUnfreePredicate =
  #   pkg:
  #   builtins.elem (lib.getName pkg) [
  #     "hp" # Printer drivers
  #     "nvidia-x11" # GPU drivers
  #     "nvidia-settings" # GPU drivers
  #     "nvidia-persistenced" # GPU drivers
  #     "ventoy" # Multiboot USB
  #   ];

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
    auto-cpufreq.enable = lib.mkDefault true; # Save battery, smarter than TLP
    tlp.enable = false; # Not with auto-cpufreq
    thermald.enable = lib.mkDefault true; # Keep CPU cool
    localtimed.enable = lib.mkDefault true;
    ntp.enable = lib.mkDefault true;
    dnscrypt-proxy2.enable = lib.mkDefault true; # See https://wiki.nixos.org/wiki/Encrypted_DNS TEST it
    usbguard.enable = true;
    logind = {
      powerKey = "hibernate";
      powerKeyLongPress = "reboot";
      lidSwitch = "suspend";
      # settings.Login = {
      #   HandlePowerKey = "hibernate";
      #   HandleLidSwitch = "suspend";
      # };
    };
    auto-cpufreq.settings = {
      battery = {
        governor = "powersave"; # Maximum battery savings
        turbo = "never"; # Maximum battery savings
      };
      # charger = { };
    };
    tlp = {
      settings = {
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 25;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        PCIE_ASPM_ON_BAT = "powersupersave";
        INTEL_GPU_MIN_FREQ_ON_AC = 500;
        INTEL_GPU_MIN_FREQ_ON_BAT = 400;
        START_CHARGE_THRESH_BAT0 = 30; # 30 and below: start to charge
        STOP_CHARGE_THRESH_BAT0 = 90; # 90 and above: don’t charge
      };
    };
    dnscrypt-proxy2 = {
      settings = {
        sources.public-resolvers = {
          urls = [
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          ];
          cache_file = "public-resolvers.md";
          # See https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"; # gitleaks:allow
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
    usbguard.IPCAllowedGroups = [ "wheel" ];
  };
}
