{ inputs, lib, config, pkgs, ... }: {
  nixpkgs = {
    overlays = [
      # use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
    };
  };

  hardware = {
    # cpu.intel.updateMicrocode = true; # TEST if set by hardware
    opengl = {
      #   enable = true; # TEST relevance
      #   driSupport = true; # TEST relevance
      #   driSupport32Bit = true; # TEST relevance
      #   extraPackages = with pkgs; [ # TEST relevance
      #     intel-media-driver
      #     vaapiIntel
      #     vaapiVdpau
      #     libvdpau-va-gl
      #   ];
    };
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    consoleLogLevel = 0;
    kernel.sysctl = { "kernel.sysrq" = 176; }; # SysRq magic keys
    # kernelParams = [ # TEST if relevant
    #   "quiet"
    #   "udev.log_level=3"
    #   "nvme.noacpi=1"
    #   "i915.force_probe=4626"
    # ];
    # extraModprobeConfig = '' # TEST if relevant
    #   blacklist hid_sensor_hub
    # # Line below is used for Focusrite sound interfaces
    #   options snd_usb_audio vid=0x1235 pid=0x8210 device_setup=1
    # '';
  };

  networking = {
    # hostName = "ninja"; # TEST if set by the flake.nix
    firewall = {
      allowedTCPPorts = [ 22000 2049 ]; # Opened TCP ports
      allowedUDPPorts = [ 22000 21027 2049 ]; # Open UDP ports
    };
  };

  security = {
    # TODO: fix fprint login
    # pam.services = {
    #   system-local-login.fprintAuth = true;
    #   # login.fprintAuth = true;
    # };
  };

  services = {
    # TODO: fix fprint login
    # fprintd = {
    #   enable = true; # Support for figerprint reader
    #   tod = {
    #     enable = true; # Support for figerprint reader
    #     driver = pkgs.libfprint-2-tod1-goodix;
    #   };
    # };
    # fstrim = {
    #   enable = true;
    # };
    fwupd.enable = true; # Update firmwares
    # tlp.enable = true; # To save some power
    # thermald.enable = true; # Try to keep cool
    geoclue2 = {
      enable = true;
    };
  };

  location.provider = "geoclue2";

  environment = {
    shells = with pkgs; [ zsh ];
    # pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      exfat
      ntfs3g
      # Graphical TEST relevance
      # mesa
      # libsForQt5.breeze-gtk
      # libsForQt5.breeze-qt5
      # libsForQt5.breeze-icons
      # libsForQt5.qt5.qtwayland
      # qt6.qtwayland
      # polkit_gnome
      # swt
    ];
    sessionVariables = {
      # TEST relevance of each
      # GTK_IM_MODULE = "ibus";
      # NIXOS_OZONE_WL = "1";
      # XCURSOR_THEME = "Nordzy-cursors";
      # WLR_DRM_NO_ATOMIC = "1";
      # WLR_NO_HARDWARE_CURSORS = "1";
      # GBM_BACKEND = "nvidia-drm";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # LIBVA_DRIVER_NAME = "nvidia";
      # QT_QPA_PLATFORM = "wayland";
      # QT_QPA_PLATFORM_PLUGIN_PATH = "/run/current-system/sw/lib";

      # QT_IM_MODULE=xim;
      # GTK_IM_MODULE=xim;
      # XMODIFIERS="@im=none";

      # SDL_VIDEODRIVER=wayland;

      # GTK_THEME = "Breeze:dark";
      # CALIBRE_USE_DARK_PALETTE = "1";
      # ANKI_WAYLAND = "1";

      # EGL_PLATFORM = "wayland";
      # MOZ_DISABLE_RDD_SANDBOX = "1";
    };
  };

  # systemd = { # TEST relevance
  #   user.services.polkit-gnome-authentication-agent-1 = {
  #     description = "polkit-gnome-authentication-agent-1";
  #     wantedBy = [ "sway-session.target" ];
  #     wants = [ "sway-session.target" ];
  #     after = [ "sway-session.target" ];
  #     serviceConfig = {
  #       Type = "simple";
  #       ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #       Restart = "on-failure";
  #       RestartSec = 1;
  #       TimeoutStopSec = 10;
  #     };
  #   };
  # };

  # qt = { # TEST if relevant
  #   enable = true;
  #   # platformTheme = "gtk2";
  #   # style = "gtk2";
  #   # platformTheme = "qt5ct";
  #   # style = "adwaita-dark";
  # };

  # xdg = { # TEST if relevant
  #   portal = {
  #     enable = true;
  #     wlr.enable = true;
  #     xdgOpenUsePortal = true;
  #   };
  #     mime = {
  #       enable = true;
  #     };
  #     autostart.enable = true;
  # };

  # system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
