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
    sops # Secret management
    devenv # Developer environments management (simpler flake.nix for dev)
    moreutils # Additional Unix utilities
    exfatprogs # Tools for exfat fs
    libnotify # Notifications management
    dislocker # decrypt bitlocker disks
    jmtpfs # Media transfer protocol with Android devices
    nixpkgs-review # Review pull requests to nixpkgs TEST
    manix # Nix documentation CLI TEST
    git-secrets # Prevent secrets leaking with Git TEST
    pipectl # Named pipes management TEST relevance
    cdrkit # ISO tools and misc TEST relevance
    # veracrypt # multiplatform encryption
    comma # Run any command from Nixpkgs
    appimage-run # Run appimages directly
    steam-run # Run in isolated FHS
    # bitwarden-cli # Modern password manager
    # keepass # Popular password manager
    keepassxc # Password manager TEST
    # keepass-keeagent # Keepass agent
  ];

  services = {
    # systembus-notify.enable = true; # TEST relevance
    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
    # pass-secret-service = {
    #   enable = true; # TEST relevence
    #   storePath = "$XDG_DATA_HOME/password-store";
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
    gpg.enable = true; # Useful cryptography tool
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };
    rbw = { # Unofficial Rust Bitwarden CLI
      enable = true;
      # See: https://searchix.alanpearce.eu/options/home-manager/search?query=programs.rbw 
    };
    password-store = {
      enable = true; # CLI standard password manager
      package =
        pkgs.pass.withExtensions (exts: [ exts.pass-otp ]); # Add OTP add-on
    };
    git = {
      enable = true; # MANDATORY
      package = pkgs.gitAndTools.gitFull; # Git with addons
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
    pointerCursor = { # Done with Hyprcursor now, TEST if still necessary
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
