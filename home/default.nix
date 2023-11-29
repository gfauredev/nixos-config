{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./zsh # Interactive POSIX shell
    ./neovim # CLI text editor
  ];

  home.packages = with pkgs; [
    # Web
    brave # Blink based secure and private web browser
    nyxt # Keyboard driven lightweight web browser

    # Theme & Style
    # libsForQt5.qt5ct # TEST if relevant
    libsForQt5.qtstyleplugin-kvantum # TEST if relevant
    # libsForQt5.qt5.qtwayland # TEST if relevant
    # qt6Packages.qt6ct # TEST if relevant
    qt6Packages.qtstyleplugin-kvantum # TEST if relevant
    # qt6.qtwayland # TEST if relevant
    # libsForQt5.systemsettings # TEST if relevant
    # adwaita-qt # TEST if relevant
    # glib # GTK Tools
    # gsettitngs-qt # GTK Settings

    # Misc
    # albert # Previous general purpose launcher
    # protonvpn-gui # Free VPN service
    # bleachbit # Good old cleaner
    # czkawka # Modern cleaner
    # stacer # Modern cleaner & monitoring
    # gnome.seahorse
    nixpkgs-review # Review pull requests to nixpkgs
    asciiquarium-transparent # Best screensaver ever
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
    home-manager.enable = true; # MANDATORY
    git = {
      enable = true; # MANDATORY
      lfs.enable = true;
      delta.enable = true;
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = false;
        };
        lfs = {
          locksverify = true;
        };
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
        credential = {
          helper = "store";
        };
      };
      ignores = [
        "*.pdf"
        "*.jpg"
        "*.jpeg"
        "*.png"
        "*.avif"
        "*.webp"
        "*.odt"
        "*.odf"
        "*.odp"
        "*.doc"
        "*.docx"
        "*.pptx"
        ".venv/"
      ];
    };
    wezterm = {
      enable = true;
      extraConfig = ''
        cfg = wezterm.config_builder() -- Base config

        ${builtins.readFile wezterm/cfg.lua}

        ${builtins.readFile wezterm/key.lua}

        return cfg
      '';
    };
    alacritty = {
      enable = true;
      settings = {
        window = {
          # opacity = 0.8;
          padding = {
            x = 2;
            y = 2;
          };
        };
        font = {
          family = "FiraCode Nerd Font";
          # size = 14;
          size = 11;
        };
        colors = {
          primary = {
            background = "#000000";
            # foreground = "#000000";
          };
        };
      };
    };
    firefox = {
      enable = true;
    };
    chromium = {
      enable = true;
    };
    # browserpass.enable = true; # TEST relevance
  };

  gtk = {
    enable = true; # TODO Apply it to every apps
    cursorTheme = {
      package = pkgs.nordzy-cursor-theme; # TEST relevance
      name = "Nordzy-cursors";
      size = 22;
    };
    font = {
      package = pkgs.fira-go;
      name = "FiraGO";
      size = 12;
    };
    # theme = { # TODO configure
    # package = pkgs.;
    # name = "";
    # };
    # iconTheme = { # TODO configure
    # package = pkgs.;
    # name = "";
    # };
    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/settings";
      # extraConfig = ''
      # '';
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      # color-scheme = "prefer-dark";
    };
  };

  qt = {
    enable = true; # FIXME
    # platformTheme = "gtk"; # TEST if relevant
    platformTheme = "qtct"; # TEST if relevant
    # style.name = "kvantum"; # TEST relevance
  };
}
