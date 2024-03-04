{ pkgs, ... }: {
  imports = [
    ../default.nix
    ../module/pulsemixer
    ../module/xplr
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Fixes https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "gf";
    homeDirectory = "/home/gf";

    sessionVariables = {
      XDG_DESKTOP_DIR = "$HOME/data";
      XDG_DOCUMENTS_DIR = "$HOME/data/document";
      XDG_DOWNLOAD_DIR = "$HOME/data";
      XDG_MUSIC_DIR = "$HOME/data/audio";
      XDG_PICTURES_DIR = "$HOME/data/image";
      XDG_VIDEOS_DIR = "$HOME/data/video";

      BROWSER = "brave"; # TODO this directly in nix

      TYPST_FONT_PATHS = "$HOME/.nix-profile/share/fonts"; # Allow Typst to find fonts
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.11";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  services = {
    syncthing = {
      enable = true;
      extraOptions = [
        "--no-default-folder"
      ];
    };
    # System-wide text expander # FIXME
    # espanso = {
    #   enable = true;
    #   configs.matches = [
    #     {
    #       # Text replacement
    #       trigger = ":name";
    #       replace = "Guilhem Fauré";
    #     }
    #     {
    #       # Date
    #       trigger = ":date";
    #       replace = "{{date}}";
    #       vars = [{
    #         name = "date";
    #         type = "date";
    #         params = { format = "%d/%m/%Y"; };
    #       }];
    #     }
    #     {
    #       # Shell command
    #       trigger = ":host";
    #       replace = "{{hostname}}";
    #       vars = [{
    #         name = "hostname";
    #         type = "shell";
    #         params = { cmd = "hostname"; };
    #       }];
    #     }
    #   ];
    # };
    # udiskie = {
    #   enable = true;
    #   automount = true;
    #   notify = true;
    #   tray = "never";
    # };
  };

  programs = {
    git = {
      userName = "Guilhem Fauré";
      userEmail = "pro@gfaure.eu";
    };
    gpg = {
      enable = true;
    };
    # TODO set an explorer that can open & preview every file
    broot = {
      enable = true; # TEST which explorer is better
      enableZshIntegration = true;
      settings = {
        # modal = true;
        default_flags = "dgps";
      };
    };
  };

  xdg = {
    enable = true;
    mime = {
      enable = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        # Text & Code
        "text/plain" = "nvim.desktop";
        "text/x-shellscript" = "nvim.desktop";
        "text/x-script.python" = "nvim.desktop";
        "text/html" = "nvim.desktop";
        "application/x-shellscript" = "nvim.desktop";
        "application/toml" = "nvim.desktop";
        "application/javascript" = "nvim.desktop";
        "text/markdown" = "nvim.desktop";
        "text/x-log" = "bat.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "text/adasrc" = "nvim.desktop";
        "text/x-adasrc" = "nvim.desktop";
        # Image
        "image/jpeg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/bmp" = "imv.desktop";
        "image/jpg" = "imv.desktop";
        "image/avif" = "imv.desktop";
        "image/webp" = "imv.desktop";
        "image/ico" = "imv.desktop";
        # Audio & Video
        "audio/wav" = "mpv.desktop";
        "audio/flac" = "mpv.desktop";
        "audio/mp3" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "video/mkv" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
        "video/avi" = "mpv.desktop";
        # Internet
        "x-scheme-handler/webcal" = "brave-browser.desktop";
        "x-scheme-handler/mailto" = "brave-browser.desktop";
        "x-scheme-handler/https" = "brave-browser.desktop";
        "x-scheme-handler/http" = "brave-browser.desktop";
        "x-scheme-handler/mailspring" = "Mailspring.desktop";
        # Documents
        "application/x-colpkg" = "anki.desktop";
        "application/x-apkg" = "anki.desktop";
        "application/x-ankiaddon" = "anki.desktop";
      };
      # associations.added = { };
    };
  };
}
