{ lib, pkgs, ... }: {
  imports = [
    ./remap.nix # Remaps for PC usability
    ../print-scan.nix # Printing & scanning service
    ../default.nix # Always import the previous default
  ];

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # Intel HD
        vaapiIntel # i965
        vaapiVdpau # Nvidia
        libvdpau-va-gl # Nvidia
      ];
    };
    uinput.enable = true;
  };

  i18n = {
    # Locales internatinalization properties
    supportedLocales = [ "en_US.UTF-8/UTF-8" "fr_FR.UTF-8/UTF-8" ];
    defaultLocale = "en_US.UTF-8"; # Set localization settings
    extraLocaleSettings = {
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_MEASUREMENTS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_COLLATE = "C";
    };
  };

  systemd.services.unmount-boot = {
    description = "Unmount /boot at boot as useless once booted";
    script =
      "${pkgs.procps}/bin/pgrep nixos-rebuild || ${pkgs.util-linux}/bin/umount /boot";
    wantedBy = [ "multi-user.target" ];
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart =
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services = {
    fwupd.enable = lib.mkDefault true; # Update firmwares
    thermald.enable = lib.mkDefault true; # Keep cool
    udisks2 = {
      enable = true; # Mount USB without privileges
      settings = { };
    };
    geoclue2 = {
      enable = true; # Location provider
    };
    xserver = {
      enable = true;
      autorun = false;
      xkb.layout = "fr,us,fr";
      xkb.variant = "bepo_afnor,,";
      xkb.options = "grp:ctrls_toggle";
      dpi = 144; # TODO better
      libinput.enable = true; # Enable touchpad support
      desktopManager.xterm.enable = false;
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
      '';
    };
    languagetool = {
      enable = true; # Advanced spell checking server
      public = false;
    };
    gnome.gnome-keyring.enable = true; # Manage secrets for apps
    gvfs.enable = true; # Samba client
    iperf3.enable = true; # Network testing
  };

  security = {
    polkit.enable = lib.mkDefault true; # Allow GUI apps to get privileges
    rtkit.enable = true; # Tools for realtime (preemption)
    # apparmor.enable = lib.mkDefault true; # TEST pertinence
  };

  location.provider = "geoclue2";

  programs = {
    dconf.enable = true; # Recommended by virtualization wiki
    gnupg = { agent.enable = true; };
    ssh.startAgent = true;
    adb.enable = true; # Talk to Android devices
    zsh.enable = true;
    firejail = {
      enable = true; # TEST pertinence
      wrappedBinaries = {
        # TODO wrap binaries properly, may need home-manager tweaks to apply to desktop apps
        # brave = {
        #   executable = "${pkgs.brave}/bin/brave";
        #   profile = "${pkgs.firejail}/etc/firejail/brave-browser.profile";
        # };
      };
    };
    wireshark.enable = true; # Network analysis
  };

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      polkit_gnome # Allow GUI apps to get privileges
      cpulimit # Limit CPU usage of processes
      libsecret # Allow apps to use gnome-keyring
      iw # Control network cards
      exfat # fs tool
      ntfs3g # fs tool
      tldr # short, examples man pages
      sshfs # browser ssh as directory
      rsync # cp through network & with superpowers
      sbctl # Secure Boot Control
      tcpdump # Dump network packets
      # dhcpcd # DHCP client
      dhcping # DHCP debugging
      dhcpdump # DHCP debugging
      # bubblewrap # Applications sandboxer TEST if better than firejail
      # samba # Share files with other OSes
      # samba4Full # Share files with other OSes
      # cifs-utils # Share files with other Oses
      inetutils # Things like FTP commend
      ath9k-htc-blobless-firmware # Firmware for Alpha wifi card
      bridge-utils # Network interface bridging
      dig # DNS analyzer
      nix-du # Determine which gc-roots take space
      ssh-to-age # Converter between SSH keys and age
    ];
  };

  # Realtime & music production related improvements
  musnix = { enable = true; };

  # Specialisation with RT kernel & performance governor by default
  # specialisation.realtime.configuration = {
  #   system.nixos.tags = [ "realtime" ];
  #   musnix = {
  #     kernel = {
  #       realtime = true; # WARNING requires a kernel recompile
  #       # TEST if below can be used without above
  #       packages = pkgs.linuxPackages_rt; # Stable RT kernel
  #       # packages = pkgs.linuxPackages_latest_rt; # Latest RT kernel
  #     };
  #   };
  # };
}
