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

  news.display = "notify"; # Notify for new home manager options

  home.packages = with pkgs; [
    nixpkgs-review # Review pull requests to nixpkgs
    manix # Nix documentation CLI
    exfatprogs # Tools for exfat fs
    dislocker # decrypt bitlocker disks
    jmtpfs # Media transfer protocol with Android devices
    git-secrets # Prevent secrets leaking with Git
    # veracrypt # multiplatform encryption
    moreutils # Additional Unix utilities
    pipectl # Named pipes management
    cdrkit # ISO tools and misc
    # GUI specific
    pinentry # Enter password when needed
    libnotify # Notifications management
    # Runing
    # comma # Run command without installing
    # appimage-run # Run appimages directly
    # steam-run # Run in isolated FHS
  ];

  services = {
    # pass-secret-service = {
    #   enable = true; # TEST relevence
    # };
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
        safe.directory = "/config"; # Flake configuration
        init.defaultBranch = "main";
        pull.rebase = false;
        lfs.locksverify = true;
        submodule = {
          recurse = true;
          fetchjobs = 8;
        };
        credential.helper = "cache 36000"; # Cache for 10 hours
        filter.lfs = {
          required = true;
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
        };
      };
      ignores = [
        "*.pdf"
        "*.jpg"
        "*.jpeg"
        "*.png"
        "*.webp"
        "*.avif"
        "*.avi"
        "*.mp4"
        "*.mkv"
        "*.wav"
        "*.mp3"
        "*.flac"
        "*.ogg"
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
    password-store = {
      enable = true; # CLI standard password manager
      package =
        pkgs.pass.withExtensions (exts: [ exts.pass-otp ]); # Add OTP add-on
    };
  };

  xdg = {
    enable = true;
    # portal = {
    #   enable = true; # TODO enable (uncomment)
    #   extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
    #   config.common.default = "*";
    # };
    mime.enable = true;
    mimeApps.enable = true;
  };

  home = {
    pointerCursor = { # Done with Hyprcursor now
      package = pkgs.bibata-cursors;
      gtk.enable = true;
      name = "Bibata-Modern-Ice";
      size = 22;
    };
    preferXdgDirectories = true;
  };

  gtk = {
    enable = true;
    # Remove this from $HOME
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/settings";
    # Dark theme everywhere
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = 1";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  qt = {
    enable = true;
    # platformTheme = "gtk"; # TEST relevance
  };
}
