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

  # gtk = { # TEST relevance
  #   cursorTheme = {
  #     name = "Nordzy-cursors";
  #   };
  # };

  # xdg = { # TEST relevance
  #   enable = true;
  #   mime = {
  #     enable = true;
  #   };
  #   mimeApps = {
  #     enable = true;
  #     defaultApplications = {
  #       "text/plain" = "nvim.desktop";
  #       "text/x-shellscript" = "nvim.desktop";
  #       "text/x-script.python" = "nvim.desktop";
  #       "text/adasrc" = "nvim.desktop";
  #       "text/x-adasrc" = "nvim.desktop";
  #       "text/html" = "nvim.desktop";
  #       "application/x-shellscript" = "nvim.desktop";
  #       "application/toml" = "nvim.desktop";
  #       "application/javascript" = "nvim.desktop";
  #       "text/markdown" = "nvim.desktop";
  #       "text/x-log" = "bat.desktop";
  #       "application/pdf" = "org.pwmt.zathura.desktop";
  #       # "image/jpeg" = "sxiv.desktop";
  #       # "image/png" = "sxiv.desktop";
  #       # "image/bmp" = "sxiv.desktop";
  #       # "image/jpg" = "sxiv.desktop";
  #       # "image/avif" = "sxiv.desktop";
  #       # "image/webp" = "sxiv.desktop";
  #       # "image/ico" = "sxiv.desktop";
  #       "image/jpeg" = "swayimg.desktop";
  #       "image/png" = "swayimg.desktop";
  #       "image/bmp" = "swayimg.desktop";
  #       "image/jpg" = "swayimg.desktop";
  #       "image/avif" = "swayimg.desktop";
  #       "image/webp" = "swayimg.desktop";
  #       "image/ico" = "swayimg.desktop";
  #       "audio/wav" = "mpv.desktop";
  #       "audio/flac" = "mpv.desktop";
  #       "audio/mp3" = "mpv.desktop";
  #       "audio/ogg" = "mpv.desktop";
  #       "video/mkv" = "mpv.desktop";
  #       "video/mp4" = "mpv.desktop";
  #       "video/avi" = "mpv.desktop";
  #       "x-scheme-handler/webcal" = "brave-browser.desktop";
  #       "x-scheme-handler/mailto" = "brave-browser.desktop";
  #       "x-scheme-handler/https" = "brave-browser.desktop";
  #       "x-scheme-handler/http" = "brave-browser.desktop";
  #       "application/x-colpkg" = "anki.desktop";
  #       "application/x-apkg" = "anki.desktop";
  #       "application/x-ankiaddon" = "anki.desktop";
  #     };
  #     associations.added = { };
  #   };
  # };
}
