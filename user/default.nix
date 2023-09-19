{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./neovim.nix
    ./helix.nix
  ];

  home.packages = with pkgs; [
    # Web
    brave # Blink based secure and private web browser
    # nyxt # Keyboard driven lightweight web browser

    # Theme & Style
    # nordzy-cursor-theme # TODO set with home manager
    libsForQt5.qt5ct # TEST if relevant
    pkgs.libsForQt5.qtstyleplugin-kvantum # TEST if relevant
    libsForQt5.qt5.qtwayland # TEST if relevant
    qt6Packages.qt6ct # TEST if relevant
    pkgs.qt6Packages.qtstyleplugin-kvantum # TEST if relevant
    qt6.qtwayland # TEST if relevant
    libsForQt5.systemsettings # TEST if relevant
    adwaita-qt # TEST if relevant

    # Misc
    albert # General purpose launcher FIXME
    # protonvpn-gui # Free VPN service
    # bleachbit
    # gnome.seahorse
  ];

  services = {
    dunst = {
      enable = true; # Notifications
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
          timeout = "10s";
        };
      };
    };
    # kanshi = { # TEST relevance
    #   enable = true;
    #   profiles = {};
    # };
    # picom = {
    #   enable = true;
    # };
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

        ${builtins.readFile ../wezterm/cfg.lua}

        ${builtins.readFile ../wezterm/key.lua}

        return cfg
      '';
      # require "cfg" -- Global options
      # require "key" -- Custom remaps
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
          # family = "Fira Code";
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
    # autorandr = { # TEST relevance
    #   enable = true;
    # };
    # eww = {
    #   enable = true;
    #   configDir = ../eww;
    # };
    # eclipse = {
    #   enable = true;
    # };
  };

  gtk = {
    enable = true;
    cursorTheme = {
      # TEST relevance
      package = pkgs.nordzy-cursor-theme;
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
    enable = true; # TEST if relevant
    # platformTheme = "gtk"; # TEST if relevant
    platformTheme = "qtct"; # TEST if relevant
    style = {
      # name = "gtk2";
      # name = "adwaita-dark";
      # name = "kvantum";
      # package = pkgs.libsForQt5.qtstyleplugins; # TEST pertinence
    };
  };
}
