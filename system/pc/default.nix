{ lib, pkgs, ... }: {
  imports = [
    ./remap.nix # Remaps for PC usability
    ../print-scan.nix # Printing & scanning service
    ../default.nix # Always import the previous default
  ];

  hardware = {
    uinput.enable = true;
    graphics.enable = true;
    # fancontrol = {
    #   enable = true;
    #   config = ''
    #     # Configuration file for fancontrol
    #   '';
    # };
  };

  i18n = {
    # Locales internatinalization properties
    supportedLocales = [ "en_GB.UTF-8/UTF-8" "fr_FR.UTF-8/UTF-8" ];
    defaultLocale = "en_GB.UTF-8"; # Set localization settings
    extraLocaleSettings = {
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_MESSAGES = "en_GB.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_MEASUREMENTS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_CTYPE = "en_GB.UTF-8";
      LC_COLLATE = "C";
    };
  };

  systemd.services.unmount-boot = {
    description = "Unmount /boot at boot as useless once booted";
    script =
      "${pkgs.procps}/bin/pgrep nixos-rebuild || ${pkgs.util-linux}/bin/umount /boot";
    wantedBy = [ "multi-user.target" ];
  };

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
    thermald.enable = lib.mkDefault true; # Keep cool
    udisks2.enable = true; # Mount USB without privileges
    libinput.enable = true; # Enable touchpad support
    hardware.bolt.enable = true; # Thunderbolt device manager (authorize eGPU…)
    gnome.gnome-keyring.enable = true; # Manage secrets for apps
    gvfs.enable = true; # Samba client
    iperf3.enable = true; # Network testing
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

  location.provider = "geoclue2";

  programs = {
    dconf.enable = true; # Recommended by virtualization wiki
    gnupg.agent.enable = true;
    ssh.startAgent = true;
    adb.enable = true; # Talk to Android devices
    zsh.enable = true;
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
    wireshark.enable = true; # Network analysis
    # nh = {
    #   enable = true; # Nix multipurpose helper
    #   flake = /config;
    #   # clean.enable = true;
    # };
    appimage = { # Run appimages directly
      enable = true;
      binfmt = true;
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
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      man-pages # Documentation
      man-pages-posix # Documentation
      cpulimit # Limit CPU usage of processes
      libsecret # Allow apps to use gnome-keyring
      iw # Control network cards
      exfat # fs tool
      ntfs3g # fs tool
      tldr # short, examples man pages
      sshfs # browser ssh as directory
      rsync # cp through network & with superpowers
      tcpdump # Dump network packets
      dhcpdump # DHCP debugging
      inetutils # Things like FTP command
      bridge-utils # Network interface bridging
      # dig # DNS analyzer
      doggo # Modern CLI DNS client
      procs # Better ps
      gping # Ping with a graph
      nix-du # Determine which gc-roots take space
      ssh-to-age # Converter between SSH keys and age
      powertop # Power usage analyzer
      just # Commands runner
      convmv # Converts filenames from one encoding to another
      enca # Detects the encoding of text files and reencodes them
      # bolt # Thunderbolt device manager
      # sbctl # Secure Boot Control
      # dhcping # DHCP debugging
      # dhcpcd # DHCP client
      # bubblewrap # Applications sandboxer TEST if better than firejail
      # samba # Share files with other OSes
      # samba4Full # Share files with other OSes
      # cifs-utils # Share files with other Oses
      # ath9k-htc-blobless-firmware # Firmware for Alpha wifi card
    ];
  };

  # services.grocy = { # TODO Find a better place to put this "user" service
  #   enable = true;
  #   hostName = "grocy.localhost";
  #   nginx.enableSSL = false;
  #   settings = {
  #     currency = "EUR";
  #     culture = "fr";
  #     calendar.firstDayOfWeek = 1;
  #   };
  # };
  # services.llama-cpp = { # TODO Find a better place to put this "user" service
  #   enable = true; # Large language model server
  #   port = 7777;
  # };
}
