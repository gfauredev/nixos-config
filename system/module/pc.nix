{ lib, pkgs, ... }: {
  imports = [
    ./remap.nix # Remaps for PC usability
    ./print-scan.nix # Printing & scanning service
    ./loginManager # Launch graphical env at login
  ];

  hardware = {
    uinput.enable = true;
    graphics.enable = true;
    # opentabletdriver.enable = true; # Open source graphic tablet driver
    # fancontrol = {
    #   enable = true;
    #   config = ''
    #     # Configuration file for fancontrol
    #   '';
    # };
  };

  systemd.services.unmount-boot = {
    description = "Unmount /boot at boot as useless once booted";
    script =
      "${pkgs.procps}/bin/pgrep nixos-rebuild || ${pkgs.util-linux}/bin/umount /boot";
    wantedBy = [ "multi-user.target" ];
  };

  security = {
    pam.services.hyprlock = { };
    polkit.enable = lib.mkDefault true; # Allow GUI apps to get privileges
    rtkit.enable = true; # Tools for realtime (preemption)
    # apparmor.enable = lib.mkDefault true; # TODO secure system
  };

  security.pam.loginLimits = [ # Increased pam limits for audio group
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "soft";
      value = "99999";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "hard";
      value = "99999";
    }
  ];

  services = {
    geoclue2 = {
      enable = true; # Location provider
      submissionUrl = "https://beacondb.net/v2/geosubmit";
      submitData = false; # Useless, laptop don’t have GPS
      geoProviderUrl = "https://beacondb.net/v1/geolocate";
      # geoProviderUrl =
      #   "https://www.googleapis.com/geolocation/v1/geolocate?key=MY_KEY"; TODO store secretly
    };
    pipewire = {
      enable = true; # Enable modern audio system PipeWire
      # audio.enable = true; # Enable modern audio system PipeWire
      wireplumber.enable = true;
      alsa.enable = true; # Support kernel audio
      alsa.support32Bit = true; # Support kernel audio
      jack.enable = true; # Support advanced audio
      pulse.enable = true; # Support previous audio system
    };
    udev = {
      packages = [
        pkgs.android-udev-rules # Talk to Android devices
      ];
      extraRules = ''
        KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"

        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      ''; # TEST relevance of latter 3, used by musnix
    };
    rustdesk-server = {
      enable = false; # TEST
      # See: https://rustdesk.com/docs/en/self-host
      signal.enable = false;
      relay.enable = false;
      openFirewall = false;
    };
    fstrim.enable = lib.mkDefault true; # Trim SSDs (better lifespan)
    fwupd.enable = lib.mkDefault true; # Update firmwares
    # thermald.enable = lib.mkDefault true; # Keep cool TEST if useful
    udisks2.enable = true; # Mount USB without privileges
    libinput.enable = true; # Enable touchpad support
    # hardware.bolt.enable = true; # Thunderbolt devs manager (authorize eGPU…)
    gnome.gnome-keyring.enable = true; # Manage secrets for apps
    gvfs.enable = true; # Samba client
    # iperf3.enable = true; # Network testing
    # smartd.enable = true; # TEST Drive health monitoring
  };

  location.provider = "geoclue2";

  i18n = { # FIXME
    # Locales internatinalization properties
    # extraLocales = [ "en_GB.UTF-8/UTF-8" "fr_FR.UTF-8/UTF-8" ];
    # extraLocales = [ "fr_FR.UTF-8/UTF-8" ];
    defaultLocale = "en_GB.UTF-8"; # Set localization settings
    extraLocaleSettings = {
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      # LC_MESSAGES = "en_GB.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_MEASUREMENTS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      # LC_CTYPE = "en_GB.UTF-8";
      # LC_COLLATE = "C";
    };
  };

  fonts.enableDefaultPackages = true; # Standard fonts

  users.groups = {
    mtp = { };
    uinput = { };
  };

  programs = {
    dconf.enable = true; # Recommended by virtualization wiki
    gnupg.agent.enable = true;
    ssh.startAgent = true;
    adb.enable = true; # Talk to Android devices
    wireshark.enable = true; # Network analysis
    ghidra.enable = true; # Reverse engineering tool
    firejail = {
      enable = true; # TODO ensure apps are jailed
      wrappedBinaries = {
        # TODO wrap binaries properly, may need home-manager tweaks to apply to desktop apps
        # brave = {
        #   executable = "${pkgs.brave}/bin/brave";
        #   profile = "${pkgs.firejail}/etc/firejail/brave-browser.profile";
        # };
      };
    };
    nix-ld.enable = true; # Run binaries
    appimage = { # Run not packaged appimages
      enable = true;
      binfmt = true;
    };
    xwayland.enable = false; # Use xwayland-satellite instead
    # uwsm.enable = true; # TEST wayland session manager
    hyprland = {
      enable = true; # Main Window Manager
      # withUWSM = true; # TEST session manager
    };
    niri = { # TEST window manager
      # See https://github.com/YaLTeR/niri
      enable = false;
    };
  };

  documentation = {
    nixos = {
      enable = true;
      includeAllModules = true;
    };
    dev.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [ # TODO clean, remove unused, move some to home
      xwayland-satellite # Wayland container that can run X11 apps
      lsof # list opened files
      zip # Universal compression
      unzip # Universal decompression
      _7zz # Compression / Decompression (7zip)
      # p7zip # Compression / Decompression compatible with 7zip
      gzip # Compression / Decompression
      bzip2 # Compression / Decompression
      usbutils # lsusb
      pciutils # lspci
      man-pages # Documentation
      man-pages-posix # Documentation
      exfat # USB sticks filesystem
      ntfs3g # Window$s filesystem
      convmv # Converts filenames from one encoding to another
      navi # Cheat sheet for CLIs
    ];
  };
}
