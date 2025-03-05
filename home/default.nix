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

  # fonts.fontconfig = {
  #   enable = true;
  #   defaultFonts = {
  #     monospace = [ "FiraCode Nerd Font" ];
  #     serif = [ "Libre Baskerville" ];
  #     sansSerif = [ "Nacelle" ];
  #     emoji = [ "Noto Color Emoji" ];
  #   };
  # };

  stylix = { # Manage all things style & appearance
    enable = true;
    polarity = "dark";
    fonts = {
      serif = {
        package = pkgs.libre-baskerville;
        name = "Libre Baskerville";
      };
      sansSerif = {
        package = pkgs.nacelle;
        name = "Nacelle";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        # package = pkgs.nerd-fonts.fira-code;
        name = "JetBrainsMono Nerd Font";
        # name = "FiraCode Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    # TODO enforce pitch black #000 background for OLED
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };
    targets.hyprlock.enable = false; # FIXME make hyprlock use stylix
  };
  # home.pointerCursor = {
  #   hyprCursor.enable = true;
  #   hyprCursor.size = config.home.pointerCursor.size;
  #   gtk.enable = true;
  # };

  home.packages = with pkgs; [ # TODO organize better, eventually in shell/
    # Machine learning
    llama-cpp # Large language model server
    # gpt4all # -cuda # TEST
    # aichat # CLI LLM chat

    # Passwords & Secrets
    # bitwarden-cli # Modern password manager
    # keepass # Popular password manager TODO sync with phone
    keepassxc # Password manager TEST
    # keepass-keeagent # Keepass agent
    gitleaks # Better tool to discover secrets in Git repo
    # git-secrets # Prevent secrets leaking with Git

    # Storage & Backup & Encryption
    restic # Efficient backup tool
    ventoy-full # create bootable keys
    testdisk # file recuperation
    exfatprogs # Tools for exfat fs
    jmtpfs # Media transfer protocol with Android devices
    # tmsu # File tagging with virtual FS
    # sendme # send files and directories p2p
    # dcfldd # more powerful dd
    # rpi-imager # Raspberry Pi OS generator
    # veracrypt # multiplatform encryption
    dislocker # decrypt bitlocker disks
  ];

  services = {
    syncthing = {
      enable = true; # Efficient P2P Syncing
      extraOptions = [ "--no-default-folder" ];
    };
    # systembus-notify.enable = true; # TEST relevance
    gpg-agent = {
      enable = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
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
      enableNushellIntegration = true;
      enableZshIntegration = true;
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

  home.preferXdgDirectories = true;

  gtk = { # TODO Stylix
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
