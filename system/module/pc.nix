{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./machine.nix # Config for actual machines, not VMs, ISOs…
    ./remap.nix # Remaps for PC usability
    ./print-scan.nix # Printing & scanning service
  ];

  hardware = {
    uinput.enable = true;
    graphics.enable = true;
    bluetooth.enable = lib.mkDefault true;
    bluetooth.powerOnBoot = lib.mkDefault true;
  };

  security = {
    polkit.enable = lib.mkDefault true; # Allow GUI apps to get privileges
    rtkit.enable = lib.mkDefault true; # Tools for realtime (preemption)
    pam.services.hyprlock = { };
    sudo.extraRules = [
      {
        groups = [ "wg" ]; # VPN without password
        runAs = "root";
        commands = [
          {
            command = "/run/current-system/sw/bin/wg-quick";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/wg";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
    sudo-rs.extraRules = config.security.sudo.extraRules; # To TEST
  };

  # fprint auth for unlock and sudo but not for login (to unlock keystore)
  security.pam.services.login.fprintAuth = false;

  security.pam.loginLimits = [
    {
      domain = "@audio"; # Increased PAM limits for audio group for realtime
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

  users.groups = {
    mtp = { };
    uinput = { };
    wg = { };
  };

  networking.firewall.enable = lib.mkDefault true;
  networking.useDHCP = lib.mkDefault true;

  services = {
    fstrim.enable = lib.mkDefault true; # Trim SSDs (better lifespan)
    fwupd.enable = lib.mkDefault true; # Update firmwares
    udisks2.enable = true; # Mount USB without privileges
    libinput.enable = true; # Enable touchpad support
    gnome.gnome-keyring.enable = true; # Manage secrets for apps
    pipewire.enable = true; # Enable modern audio system PipeWire
    geoclue2.enable = true; # Location provider
    rustdesk-server.enable = false; # See https://rustdesk.com/docs/en/self-host
    protonmail-bridge.enable = true; # Use Proton Mail inside client
    hardware.bolt.enable = lib.mkDefault false; # Thunderbolt devices manager
    gvfs.enable = lib.mkDefault true; # Samba client
    pipewire = {
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
    geoclue2 = {
      submitData = false; # Useless, laptop don’t have GPS
      submissionUrl = "https://beacondb.net/v2/geosubmit";
      geoProviderUrl = "https://beacondb.net/v1/geolocate";
      # geoProviderUrl="https://www.googleapis.com/geolocation/v1/geolocate?key=MY_KEY";
    };
    protonmail-bridge.path = [ pkgs.gnome-keyring ];
    rustdesk-server = {
      signal.enable = false;
      relay.enable = false;
      openFirewall = false;
    };
  };

  location.provider = "geoclue2";

  # systemd.services.unmount-boot = {
  #   description = "Unmount /boot at boot as it’s useless once booted";
  #   script = "${pkgs.procps}/bin/pgrep nixos-rebuild || ${pkgs.util-linux}/bin/umount /boot";
  #   wantedBy = [ "multi-user.target" ];
  # };

  # dejavu_fonts, freefont_ttf, gyre-fonts, TrueType substitutes
  # liberation_ttf, unifont, noto-fonts-color-emoji
  fonts.enableDefaultPackages = true;

  programs = {
    hyprland.enable = true; # Main Window Manager
    xwayland.enable = false; # Use xwayland-satellite instead
    dconf.enable = true; # Recommended by virtualization wiki
    gnupg.agent.enable = true;
    ssh.startAgent = !config.services.gnome.gnome-keyring.enable;
    firejail.enable = true; # See https://wiki.nixos.org/wiki/Firejail TODO
    adb.enable = lib.mkDefault true; # Talk to Android devices
    wireshark.enable = true; # Network analysis
    ghidra.enable = true; # Reverse engineering tool
    # appimage.enable = true; # Run appimages TEST if better way
    # nix-ld.enable = true; # Run binaries, instead: https://nixos-and-flakes.thiscute.world/best-practices/run-downloaded-binaries-on-nixos
    # uwsm.enable = true; # TEST wayland session manager
    # niri.enable = true; # See https://github.com/YaLTeR/niri
  };

  documentation = {
    nixos.enable = true;
    dev.enable = true;
    nixos.includeAllModules = true;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite # Wayland container that can run X11 apps TEST relevance
    # man-pages # Documentation
    # man-pages-posix # Documentation
    # navi # Cheat sheet for CLIs
  ];
}
