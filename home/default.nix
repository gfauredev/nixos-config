{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./zsh.nix # Shell
    ./neovim.nix # Main editor
    ./helix.nix # Potential future editor
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

    # Misc
    # albert # Previous general purpose launcher
    # protonvpn-gui # Free VPN service
    # bleachbit
    # gnome.seahorse
    nixpkgs-review # Review pull requests to nixpkgs
  ];

  services = {
    dunst = {
      enable = true; # Notifications daemon
      settings = {
        global = {
          width = 600;
          height = 28 * 3; # Triple of status bar height
          corner_radius = 15;
          frame_width = 0;
          origin = "bottom-center";
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
      ];
    };
    wezterm = {
      enable = true;
      extraConfig = ''
        cfg = wezterm.config_builder() -- Base config

        ${builtins.readFile ../script+data/wezterm/cfg.lua}

        ${builtins.readFile ../script+data/wezterm/key.lua}

        return cfg
      '';
    };
    alacritty = {
      enable = true;
      settings = {
        window = {
          opacity = 0.8;
          padding = {
            x = 2;
            y = 2;
          };
        };
        font = {
          family = "FiraCode Nerd Font";
          size = 14;
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
    # font = { # TODO configure
    # package = pkgs.;
    # name = "";
    # size = 20;
    # };
    # theme = { # TODO configure
    # package = pkgs.;
    # name = "";
    # };
    # iconTheme = { # TODO configure
    # package = pkgs.;
    # name = "";
    # };
  };

  qt = {
    enable = true; # FIXME
    # platformTheme = "gtk"; # TEST if relevant
    platformTheme = "qtct"; # TEST if relevant
    # style.name = "kvantum"; # TEST relevance
  };
}
