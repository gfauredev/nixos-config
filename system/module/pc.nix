{
  config,
  lib,
  pkgs,
  ...
}: # Personal Computer
{
  imports = [
    ./machine.nix # Config for actual machines, not VMs, ISOs…
    ./loginManager # Launch graphical env at login
    ./secureboot.nix # Secure Boot (Lanzaboote)
    ./remap.nix # Remaps for PC usability
    ./print-scan.nix # Printing & scanning service
    ./i18n.nix # Internationalization
  ];

  hardware = {
    uinput.enable = true;
    graphics.enable = true;
    bluetooth.enable = lib.mkDefault true;
    bluetooth.powerOnBoot = lib.mkDefault true;
  };
  # Run non native binaries seamlessly
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "wasm32-wasi"
    "wasm64-wasi"
    "x86_64-windows"
  ];

  security = {
    polkit.enable = lib.mkDefault true; # Allow GUI apps to get privileges
    rtkit.enable = lib.mkDefault true; # Tools for realtime (preemption)
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
  security.pam = {
    services = {
      login.fprintAuth = false; # fprint auth for unlock, sudo … NOT for login (allow keystore unlock)
      hyprlock = { }; # Hyprland screen locker
    };
    loginLimits = [
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
  };
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
      # packages = [ pkgs.android-udev-rules ]; # Talk to Android devices
      # 1. Uinput device for virtual input (keyboards, mice…)
      # 2. Used in Musnix for audio latency reduction
      # 3. USB Blaster for FPGA programming
      extraRules = ''
        KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"

        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"

        SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", MODE="0666"
        SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6002", MODE="0666"
        SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6003", MODE="0666"
        SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6010", MODE="0666"
        SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6810", MODE="0666"

        SUBSYSTEM=="usb", ATTRS{manufacturer}=="NVIDIA Corp.", ATTRS{product}=="APX", GROUP="wheel"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666", GROUP="wheel"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0955", ATTRS{idProduct}=="7321", MODE="0666", GROUP="wheel"
      '';
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
    fuse.enable = true;
    # appimage.enable = true; # Run AppImages TEST if better way
    # appimage.binfmt = true; # Run AppImages seamlessly
    # nix-ld.enable = true; # Run binaries, instead: https://nixos-and-flakes.thiscute.world/best-practices/run-downloaded-binaries-on-nixos
    # uwsm.enable = true; # TEST wayland session manager
    # niri.enable = true; # See https://github.com/YaLTeR/niri
    fuse.userAllowOther = true;
  };
  environment.systemPackages = with pkgs; [
    # minicom # Serial TODO keep only one
    # picocom # Serial
    # screen # Serial
    tio # Serial
    xwayland-satellite # Wayland container that can run X11 apps TEST relevance
  ];
}
