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
    # config = { # TEST pertinence
    #   allowUnfree = true;
    # };
  };

  i18n = {
    # TODO place this in home config
    # Locales internatinalization properties
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
    ];
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

  services = {
    # TODO this may belong to home config
    fwupd.enable = lib.mkDefault true; # Update firmwares
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
      layout = "fr,us,fr";
      xkbVariant = "bepo_afnor,,";
      xkbOptions = "grp:ctrls_toggle";
      dpi = 144; # TODO enable this without xserver
      libinput.enable = true; # Enable touchpad support
      desktopManager.xterm.enable = false;
    };
    pipewire = {
      enable = true; # Enable modern audio system PipeWire
      alsa.enable = true; # Support kernel audio
      jack.enable = true; # Support advanced audio
      pulse.enable = true; # Support previous audio system
    };
    udev.packages = [
      pkgs.android-udev-rules # Talk to Android devices
    ];
  };

  location.provider = "geoclue2";

  programs = {
    gnupg = {
      agent.enable = true;
      agent.pinentryFlavor = "curses";
    };
    ssh.startAgent = true;
    adb.enable = true; # Talk to Android devices
    zsh.enable = true;
    firejail = {
      enable = true; # TEST pertinence
      wrappedBinaries = { };
    };
  };

  environment = {
    shells = with pkgs; [ zsh ];
    # pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      exfat # fs tool
      ntfs3g # fs tool
      tldr # short man pages
      sshfs # browser ssh as directory
      rsync # cp through network & with superpowers
      sbctl # Secure Boot Control
      sbsigntool # Secure Boot Sign
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
}
