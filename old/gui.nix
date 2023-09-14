{ config, lib, pkgs, ... }: {
  imports =
    [
      ./gf.nix # my own user basics settings
      ./interception-tools.nix # remap caps lock to esc+ctrl
      <musnix> # Realtime & general audio enhancements
    ];

  home-manager.users.gf = { pkgs, ... }: {
    imports = [
      ./sway.nix # sway wm config
      ./i3.nix # i3 wm config
    ];


  };


  services.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      # xcompmgr
      xorg.xauth
      feh
      i3lock
      xclip
      xsel
      xorg.xev # Evaluate input
    ];
  };

  programs = {
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        swayidle
        swaylock
        wlr-randr
        wl-clipboard
        kanshi
        wl-color-picker
        pcmanfm
        grim
        slurp
        wev
        swaybg
        autotiling
        # autotiling-rs
        # wpaperd
        # fuzzel
        # eww
      ];
    };
    xwayland.enable = true;
  };

  # qt = {
  #   enable = true;
  #   # platformTheme = "gtk2";
  #   # style = "gtk2";
  #   # platformTheme = "qt5ct";
  #   # style = "adwaita-dark";
  # };

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      # xdgOpenUsePortal = true;
    };
    #   mime = {
    #     enable = true;
    #   };
    #   autostart.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "sway-session.target" ];
      wants = [ "sway-session.target" ];
      after = [ "sway-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  environment = {
    sessionVariables = {
      GTK_IM_MODULE = "ibus";
      NIXOS_OZONE_WL = "1";
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

      GTK_THEME = "Breeze:dark";
      # CALIBRE_USE_DARK_PALETTE = "1";
      ANKI_WAYLAND = "1";

      # EGL_PLATFORM = "wayland";
      # MOZ_DISABLE_RDD_SANDBOX = "1";
    };

    systemPackages = with pkgs; [
      mesa
      # libsForQt5.breeze-gtk
      # libsForQt5.breeze-qt5
      # libsForQt5.breeze-icons
      # libsForQt5.qt5.qtwayland
      # qt6.qtwayland
      polkit_gnome
      # swt
    ];
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  musnix = {
    enable = true;
    kernel = {
      # realtime = true;
    };
  };
}
