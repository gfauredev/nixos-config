{ inputs, lib, config, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      # Text & Document
      zathura # Minimalist PDF reader
      masterpdfeditor4 # PDF editor
      libreoffice-fresh # Office suite
      # libreoffice-qt # Office suite
      # libreoffice # Office suite
      # libreoffice-fresh-unwrapped # Office suite
      # libreoffice-still # Office suite
      anki-bin # Memorisation
      # languagetool # Grammar checking
      # appflowy
      # xournalpp
      # write_stylus
      # markdown-anki-decks
      # logseq # Outliner note taking
      # marktext # markdown editor
      # calibre # Ebook management

      # Utilities & Software
      # albert # General purpose launcher
      xdg-utils # Mime type based file oppening
      tesseract # OCR on PDF or images
      qbittorrent-nox # CLI Bittorrent client
      fontforge # Font editor
      # qbittorrent # Bittorrent client
      # appimage-run # Run appimages directly
      # steam-run # Run in isolated FHS
      # gnome.simple-scan # Document scanner
      # transmission-qt # Bittorrent client
      # filezilla # FTP client
      # xbanish # Hide mouse Xorg
      # emacsPackages.org-roam-ui
      # hovercraft # impress.js presentations
      # sqldeveloper # PROPRIETARY SQL Oracle IDE
      # sqlcl # Oracle DB CLI
      # emanote # Structured view text notes
      # insomnia # REST client
      # steam # PROPRIETARY video games store and launcher
      # heroic # gog and epic games launcher
      # legendary-gl # epic games launcher alternative
      # gogdl # gog dl module for heroic launcher
      # gamescope # steamos compositing manager
      # handlr # Default app launcher
      # obs-studio
      # obs-studio-plugins.wlrobs
      # obs-wlrobs
      # dbeaver # Database (SQL) analyzer
      # gns3-gui # Network simulator
      # umlet
      # android-studio
      # usbimager
      # webtorrent_desktop
      # gnome.seahorse
      # bleachbit
      # rnote
      # blueman
      # nodePackages.browser-sync # Live website preview, use apache instead
      # chntpw # Access Windows (dual boot) registry

      # Web & Communications
      brave # Blink based secure and private web browser
      firefox # Gecko based web browser
      signal-desktop # Secure messaging
      # discord # PROPRIETARY messaging and general communication
      # nyxt # Keyboard driven lightweight web browser
      chromium # Blink based web browser
      # discord-canary # PROPRIETARY messaging and general communication
      # teams-for-linux # PROPRIETARY services messaging and work
      # protonvpn-gui # Free VPN service
      # zoom         # PROPRIETARY messaging and work
      mailspring # mail client

      # Music & Sound
      spotify # PROPRIETARY music streaming
      playerctl # MPRIS media players control
      klick # Metronome
      qpwgraph # PipeWire flux visualisation and control
      ardour # Full fledged digital audio workstation
      distrho # Repository of audio plugins
      easyeffects # Realtime pipewire effects
      drumgizmo # High quality drums sampler
      # audacity # Simple audio editor
      # alsa-scarlett-gui
      # geonkick
      # surge-XT
      # lsp-plugins
      # fluidsynth
      # linuxsampler
      # qsampler
      # helm
      # drumkv1
      # samplv1
      # surge

      # Image & Video & 3D
      swayimg # image viewer
      # sxiv # image viewer
      mpv
      openscad
      gimp # image editor
      # krita # image editor
      inkscape # vector image editor
      # blender # 3D, animation & video editor
      # shotcut # video editor
      libsForQt5.kdenlive # video editor
      # davinci-resolve # PROPRIETARY video editor
      # glaxnimate # video editing library
      # flowblade # non linear video editor
      # olive-editor # non linear video editor
      # natron # non linear video editor
      # freecad
      # ideamaker
      darktable # RAW pictures editing
      # imv

      # Theme & Style
      nordzy-cursor-theme
    ];

    programs = {
      zsh.loginExtra = ''
        # start window managers at login on first & second tty
        # & ensure veracrypt devices dismount at logout
        if [ -z "''${DISPLAY}" ]; then
          if [ "''${XDG_VTNR}" -eq 1 ]; then
            exec sh -c "$HOME/.nix-profile/bin/sway; veracrypt -t -d"
          fi
          if [ "''${XDG_VTNR}" -eq 2 ]; then
            exec sh -c "startx $HOME/.nix-profile/bin/i3; veracrypt -t -d"
          fi
        fi
      '';
      i3status-rust = {
        enable = true;
        bars = {
          bottom = {
            blocks = [
              {
                block = "time";
                interval = 1;
                format = "$timestamp.datetime(f:'%H:%M:%S | %A %d %B %Y')";
              }
              { block = "sound"; }
            ];
            settings = {
              theme.theme = "solarized-dark";
            };
          };
        };
      };
      wezterm = {
        enable = true;
        extraConfig = ''
          cfg = wezterm.config_builder() -- Base config
          require "cfg" -- Global options
          require "key" -- Custom remaps
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
            # family = "Fira Code";
            family = "FiraCode Nerd Font";
            size = 14;
          };
        };
      };
      zathura = {
        enable = true;
        extraConfig = ''
          set sandbox none
          set selection-clipboard clipboard

          set scroll-step 50
          set scroll-hstep 10

          map t scroll down
          map s scroll up
          map T navigate next
          map S navigate previous
          map c scroll left
          map r scroll right

          map R rotate rotate-cw
          map C rotate rotate-ccw

          map b recolor
        '';
      };
      autorandr = {
        enable = true;
      };
      # eww = {
      #   enable = true;
      #   configDir = ../eww;
      # };
      # eclipse = {
      #   enable = true;
      # };
      java.enable = true;
    };

    services = {
      dunst = {
        enable = true;
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
      # kanshi = {
      #   enable = true;
      #   profiles = {};
      # };
      # picom = {
      #   enable = true;
      # };
      mpris-proxy.enable = true;
    };

    gtk = {
      cursorTheme = {
        name = "Nordzy-cursors";
      };
    };

    xdg = {
      enable = true;
      mime = {
        enable = true;
      };
      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/plain" = "nvim.desktop";
          "text/x-shellscript" = "nvim.desktop";
          "text/x-script.python" = "nvim.desktop";
          "text/adasrc" = "nvim.desktop";
          "text/x-adasrc" = "nvim.desktop";
          "text/html" = "nvim.desktop";
          "application/x-shellscript" = "nvim.desktop";
          "application/toml" = "nvim.desktop";
          "application/javascript" = "nvim.desktop";
          "text/markdown" = "nvim.desktop";
          "text/x-log" = "bat.desktop";
          "application/pdf" = "org.pwmt.zathura.desktop";
          # "image/jpeg" = "sxiv.desktop";
          # "image/png" = "sxiv.desktop";
          # "image/bmp" = "sxiv.desktop";
          # "image/jpg" = "sxiv.desktop";
          # "image/avif" = "sxiv.desktop";
          # "image/webp" = "sxiv.desktop";
          # "image/ico" = "sxiv.desktop";
          "image/jpeg" = "swayimg.desktop";
          "image/png" = "swayimg.desktop";
          "image/bmp" = "swayimg.desktop";
          "image/jpg" = "swayimg.desktop";
          "image/avif" = "swayimg.desktop";
          "image/webp" = "swayimg.desktop";
          "image/ico" = "swayimg.desktop";
          "audio/wav" = "mpv.desktop";
          "audio/flac" = "mpv.desktop";
          "audio/mp3" = "mpv.desktop";
          "audio/ogg" = "mpv.desktop";
          "video/mkv" = "mpv.desktop";
          "video/mp4" = "mpv.desktop";
          "video/avi" = "mpv.desktop";
          "x-scheme-handler/webcal" = "brave-browser.desktop";
          "x-scheme-handler/mailto" = "brave-browser.desktop";
          "x-scheme-handler/https" = "brave-browser.desktop";
          "x-scheme-handler/http" = "brave-browser.desktop";
          "application/x-colpkg" = "anki.desktop";
          "application/x-apkg" = "anki.desktop";
          "application/x-ankiaddon" = "anki.desktop";
        };
        associations.added = { };
      };
    };
  };
}
