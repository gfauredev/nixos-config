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
      # sans = sansSerif; # Alias
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
        # package = pkgs.nerd-fonts.fira-code;
        # name = "FiraCode Nerd Font";
      };
      # mono = monospace; # Alias
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    # Based on Catppuccin Mocha, but with pitch black #000 background for OLED
    base16Scheme = { # https://catppuccin.com/palette
      # base00 = "#1e1e2e"; # base, default background
      base00 = "#000000"; # pitch black, default background
      base01 = "#181825"; # mantle, alternate background
      base02 = "#313244"; # surface0, selection background
      base03 = "#45475a"; # surface1
      base04 = "#585b70"; # surface2, alternate text
      base05 = "#cdd6f4"; # text, default text
      base06 = "#f5e0dc"; # rosewater
      base07 = "#b4befe"; # lavender
      base08 = "#f38ba8"; # red, error
      base09 = "#fab387"; # peach, urgent
      base0A = "#f9e2af"; # yellow, warning
      base0B = "#a6e3a1"; # green
      base0C = "#94e2d5"; # teal
      base0D = "#89b4fa"; # blue
      base0E = "#cba6f7"; # mauve
      base0F = "#f2cdcd"; # flamingo
      # Added based on Helix’s Catppuccin Mocha theme
      base10 = "#f5c2e7"; # pink
      base11 = "#eba0ac"; # maroon
      base12 = "#89dceb"; # sky
      base13 = "#74c7ec"; # sapphire
      base14 = "#bac2de"; # subtext1
      base15 = "#a6adc8"; # subtext0
      base16 = "#9399b2"; # overlay2
      base17 = "#7f849c"; # overlay1
      base18 = "#6c7086"; # overlay0
      base19 = "#11111b"; # crust
      # Additional
      base1A = "#2a2b3c"; # cursorline
      base1B = "#b5a6a8"; # secondary_cursor
      base1C = "#878ec0"; # secondary_cursor_normal
      base1D = "#7ea87f"; # secondary_cursor_insert
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };
    # FIXME ugly looking, https://github.com/chriskempson/base16/blob/main/styling.md
    targets.helix.enable = false; # FIXME color theme not compatible treesitter
  };

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
    git-filter-repo # Quickly rewrite history

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
