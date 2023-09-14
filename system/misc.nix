# Ideally find a semantic place to refile those settings
{ inputs, lib, config, pkgs, ... }: {
  services = {
    localtimed.enable = true;
    nfs.server.enable = true;
    # cachix-agent.enable = true;
    pipewire = {
      enable = true; # Enable modern audio system PipeWire
      alsa.enable = true; # Enable support for old audio system
      jack.enable = true; # Enable support for old audio system
      pulse.enable = true; # Enable support for old audio system
    };
    udisks2 = {
      enable = true;
      settings = { };
    };
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "never";
    };
    syncthing = {
      enable = true;
    };
    udev.packages = [
      pkgs.android-udev-rules
    ];
  };

  programs = {
    # zsh.enable = true; TODO: test pertinence with hm
    gnupg = {
      agent.enable = true;
      agent.pinentryFlavor = "curses";
    };
    # firejail = { # TODO: test pertinence
    #   enable = true;
    #   wrappedBinaries = { };
    # };
    adb.enable = true;
    ssh.startAgent = true;
  };

  environment = {
    shells = with pkgs; [ zsh ];
    # pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      age
      gnupg
      openssl
      libsecret

      zip
      unzip
      p7zip
      gzip
      bzip2
      bzip3
      librsvg

      exfat
      ntfs3g

      # Graphical
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

  security = {
    sudo.enable = true;
    # polkit.enable = true; # TODO: test pertinence
    # apparmor.enable = true; # TODO: test pertinence
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

  # hardware.opengl = { # TEST relevance
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };

  # musnix = { # TEST relevance
  #   enable = true;
  #   kernel = {
  #     # realtime = true;
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
}
