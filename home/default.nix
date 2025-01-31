{ config, pkgs, ... }: {
  programs.home-manager.enable = true; # MANDATORY

  imports = [
    ./shell # Interactive POSIX shell(s)
  ];

  manual = {
    html.enable = true;
    json.enable = true;
    manpages.enable = true;
  };

  news.display = "notify"; # Notify for new home manager options

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "FiraCode Nerd Font" ];
      serif = [ "Libre Baskerville" ];
      sansSerif = [ "Nacelle" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  home.packages = with pkgs; [ # TODO organize better, eventually in shell/
    devenv # Developer environments management (simpler flake.nix for dev)
    moreutils # Additional Unix utilities
    pipectl # Named pipes management TEST relevance
    cdrkit # ISO tools and misc TEST relevance
    # libnotify # Notifications management

    exfatprogs # Tools for exfat fs
    jmtpfs # Media transfer protocol with Android devices

    rustdesk # Modern remote desktop
    browsh # CLI web browser
    manix # Nix documentation CLI
    nixpkgs-review # Review pull requests to nixpkgs TEST

    sops # Secret management
    gitleaks # Better tool to discover secrets in Git repo
    # git-secrets # Prevent secrets leaking with Git
    dislocker # decrypt bitlocker disks
    # veracrypt # multiplatform encryption

    comma # Run any command from Nixpkgs
    steam-run # Run in isolated FHS

    # bitwarden-cli # Modern password manager
    # keepass # Popular password manager
    keepassxc # Password manager TEST
    # keepass-keeagent # Keepass agent

    # Machine learning tools
    gpt4all # -cuda # TEST
    llama-cpp # Large language model server
    # aichat # CLI LLM chat

    # Storage & Backup
    restic # Efficient backup tool
    ventoy-full # create bootable keys
    testdisk # file recuperation
    # tmsu # File tagging with virtual FS
    # sendme # send files and directories p2p
    # udiskie # auto mount USB
    # dcfldd # more powerful dd
    # rpi-imager # Raspberry Pi OS generator

    # Miscellaneous
    jq # JSON parsing and request tool USED BY HYPRLAND CONFIG
    kalker # Evaluate math expression
    watchexec # Run command when file changes
    hyperfine # Benchmark commands
    uv # Python package and project manager TODO reorg
    # cachix # CLI cachix client TODO reorg
  ];

  services = {
    syncthing = {
      enable = true; # Efficient P2P Syncing
      extraOptions = [ "--no-default-folder" ];
    };
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
    ollama.enable = true; # Large language model inference server
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
      delta = {
        enable = true;
        options.navigate = true;
      };
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
        merge.conflictstyle = "zdiff3";
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
