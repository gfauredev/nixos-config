{ config, pkgs, ... }: {
  programs.home-manager.enable = true; # MANDATORY

  imports = [
    ./shell # Interactive POSIX shell
    ./lib/font.nix # My favorite fonts
  ];

  manual = {
    html.enable = true;
    json.enable = true;
    manpages.enable = true;
  };

  news.display = "show";

  home.packages = with pkgs; [
    nixpkgs-review # Review pull requests to nixpkgs
    manix # Nix documentation CLI
    comma # Run command without installing
    exfatprogs # Tools for exfat fs
    dislocker # decrypt bitlocker disks
    # veracrypt # multiplatform encryption
    jmtpfs # Media transfer protocol with Android devices
    # pass # CLI standard password manager
    # git-secrets # Encrypted storage in public git repo
    # GUI specific
    pinentry # enter passwords
    libnotify # Notifications management
    # appimage-run # Run appimages directly
    # steam-run # Run in isolated FHS
  ];

  services = {
    dunst = {
      enable = true; # Notifications daemon
      settings = {
        global = {
          width = 400;
          height = 100; # About the triple of status bar height
          corner_radius = 15;
          frame_width = 0;
          # origin = "bottom-center";
          origin = "bottom-right";
          offset = "0x-28"; # Lowered to align with status bar
          background = "#000000cc"; # As transparent as status
          foreground = "#def";
          separator_color = "auto";
          font = "FiraCode Nerd Font";
          timeout = "6s";
        };
      };
    };
  };

  programs = {
    git = {
      enable = true; # MANDATORY
      lfs.enable = true;
      delta.enable = true;
      extraConfig = {
        init = { defaultBranch = "main"; };
        pull = { rebase = false; };
        lfs = { locksverify = true; };
        filter.lfs = {
          required = true;
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
        };
        submodule = {
          recurse = true;
          fetchjobs = 8;
        };
        credential = { helper = "store"; };
      };
      ignores = [
        "*.pdf"
        "*.jpg"
        "*.jpeg"
        "*.png"
        "*.webp"
        "*.avif"
        "*.odt"
        "*.odf"
        "*.odp"
        "*.doc"
        "*.docx"
        "*.pptx"
        ".venv/"
        ".vagrant/"
        "build/"
        "public/"
        "*ignore*"
      ];
    };
    gpg.enable = true; # Useful cryptography tool
    password-store.enable = true; # CLI standard password manager
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = true;
  };

  home = {
    pointerCursor = {
      package = pkgs.bibata-cursors;
      # package = pkgs.nordzy-cursor-theme;
      gtk.enable = true;
      name = "Bibata-Modern-Ice";
      size = 22;
      # x11.enable = true; # TEST relevance
    };
    preferXdgDirectories = true;
  };

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/settings";
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = 1";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  qt = {
    enable = true;
    # platformTheme = "gtk"; # TEST relevance
  };
}
