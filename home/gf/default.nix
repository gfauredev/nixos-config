{ pkgs, ... }: {
  imports = [
    ../default.nix
    ../module/pulsemixer
    ../module/xplr
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Fixes https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "gf";
    homeDirectory = "/home/gf";

    sessionVariables = {
      XDG_DESKTOP_DIR = "$HOME/data";
      XDG_DOCUMENTS_DIR = "$HOME/data/document";
      XDG_DOWNLOAD_DIR = "$HOME/data";
      XDG_MUSIC_DIR = "$HOME/data/audio";
      XDG_PICTURES_DIR = "$HOME/data/image";
      XDG_VIDEOS_DIR = "$HOME/data/video";

      BROWSER = "brave"; # TODO this directly in nix

      TYPST_FONT_PATHS = "$HOME/.nix-profile/share/fonts"; # Allow Typst to find fonts
    };

    packages = with pkgs; [
      #################### Encryption & Network ####################
      # git-secrets # Encrypted storage in public git repo
      pass # CLI password manager
      pinentry # enter passwords
      dislocker # decrypt bitlocker
      # veracrypt # multiplatform encryption
      # cryptsetup # TEST relevance
      # wireguard-tools # TEST relevance
      # rustscan # scan networks
      nmap # scan ports
      # signal-cli # Secure messaging
      xh # User-friendly HTTP client similar to HTTPie
      # curl # Mythic HTTP client TEST xh only
      # hping # Network monitoring tool
      thc-hydra # Pentesting tool
      # tshark # Wireshark CLI
      wireshark # Wireshark GUI
      # termshark # Wireshark TUI
      iperf # IP bandwidth measuring

      #################### Languages helpers ####################
      ltex-ls # Grammar language server
      hunspell # Natural language spell checker
      hunspellDicts.fr-any # For french
      hunspellDicts.en_US # For english
      hunspellDicts.en_GB-ise # For english
      hunspellDicts.es_ES # For spanish
      typst # Document processor
      typst-lsp # Document processor LSP
      typstfmt # Typst formatter
      marksman # Markdown
      nil # Nix LSP
      rnix-lsp # Nix LSP
      nodePackages_latest.bash-language-server # Bash LSP
      lua-language-server # Lua
      nodePackages_latest.prettier # General purpose formatter

      ############### Miscelaneous / TODO refile ###############
      jmtpfs # Media transfer protocol with Android devices
      libnotify # Notifications management
      watchexec # Run command when file changes
      hyperfine # benchmark
      jq # JSON filter
      kismet # Wireless network sniffer
      rpi-imager # Raspberry Pi OS generator
      cmatrix # Simulate falling text as in matrix
      valent # kdeconnect protocol (bilateral Android remote control)
      ollama # Run LLMs locally
      # open-interpreter # Interpret LLM code in terminal directly
      # anytype # General productivity app
      # appimage-run # Run appimages directly
      # steam-run # Run in isolated FHS
      # poetry # Python project manager # TODO use nix instead
      # python3 # Python # TODO USE nix instead
      conda # Python package manager
      # procs # better ps
      # pulseaudio # TEST relevance
      # cachix # TEST relevance
      # android-file-transfer
      # android-tools # ADB & Fastboot
      # android-udev-rules
      # interception-tools # TEST relevance
      # bluetooth_battery # TEST relevance
      # rustdesk # Remote desktop
      # eva # Evaluate math expression
      # dwfv
      # inetutils
      # spotify-tui
      # khal # Calendar compatible with WebCal
      # entr # Run command when file changes
      # cpulimit
      # undervolt
      # cpufrequtils
      # pcscliteWithPolkit
      qpdf # PDF manipulation
    ];

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.11";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  services = {
    # udiskie = {
    #   enable = true;
    #   automount = true;
    #   notify = true;
    #   tray = "never";
    # };
    syncthing = {
      enable = true;
      extraOptions = [
        "--no-default-folder"
      ];
    };
    # System-wide text expander # FIXME
    # espanso = {
    #   enable = true;
    #   configs.matches = [
    #     {
    #       # Text replacement
    #       trigger = ":name";
    #       replace = "Guilhem Fauré";
    #     }
    #     {
    #       # Date
    #       trigger = ":date";
    #       replace = "{{date}}";
    #       vars = [{
    #         name = "date";
    #         type = "date";
    #         params = { format = "%d/%m/%Y"; };
    #       }];
    #     }
    #     {
    #       # Shell command
    #       trigger = ":host";
    #       replace = "{{hostname}}";
    #       vars = [{
    #         name = "hostname";
    #         type = "shell";
    #         params = { cmd = "hostname"; };
    #       }];
    #     }
    #   ];
    # };
  };

  programs = {
    git = {
      userName = "Guilhem Fauré";
      userEmail = "pro@gfaure.eu";
    };
    gpg = {
      enable = true;
    };
    # TODO set an explorer that can open & preview every file
    broot = {
      enable = true; # TEST which explorer is better
      enableZshIntegration = true;
      settings = {
        # modal = true;
        default_flags = "dgps";
      };
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
        "text/html" = "nvim.desktop";
        "application/x-shellscript" = "nvim.desktop";
        "application/toml" = "nvim.desktop";
        "application/javascript" = "nvim.desktop";
        "text/markdown" = "nvim.desktop";
        "text/x-log" = "bat.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "text/adasrc" = "nvim.desktop";
        "text/x-adasrc" = "nvim.desktop";

        "image/jpeg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/bmp" = "imv.desktop";
        "image/jpg" = "imv.desktop";
        "image/avif" = "imv.desktop";
        "image/webp" = "imv.desktop";
        "image/ico" = "imv.desktop";

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
        "x-scheme-handler/mailspring" = "Mailspring.desktop";

        "application/x-colpkg" = "anki.desktop";
        "application/x-apkg" = "anki.desktop";
        "application/x-ankiaddon" = "anki.desktop";
      };
      # associations.added = { };
    };
  };
}
