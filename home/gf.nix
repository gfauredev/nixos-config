{ inputs, lib, config, pkgs, ... }: {
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
      XDG_DESKTOP_DIR = "$HOME";
      XDG_DOCUMENTS_DIR = "$HOME/doc";
      XDG_DOWNLOAD_DIR = "$HOME/dl";
      XDG_MUSIC_DIR = "$HOME/audio";
      XDG_PICTURES_DIR = "$HOME/img";
      XDG_VIDEOS_DIR = "$HOME/vid";

      BROWSER = "brave"; # TODO this directly in nix

      TYPST_FONT_PATHS = "$HOME/.nix-profile/share/fonts"; # Allow Typst to find fonts
    };

    packages = with pkgs; [
      #################### Serif Fonts ####################
      merriweather # Serif readable on low res screens
      vollkorn # Great serif font
      libre-baskerville # Great, stylish serif
      # gelasio # Serif Georgia replacement
      # lmodern # Classic serif
      # noto-fonts-cjk-serif
      #################### Sans Fonts ####################
      fira-go # Great sans with icons
      nacelle # Helvetica replacement
      # inter # Interesting sans font
      # carlito # Calibri replacement
      # merriweather-sans # Sans font readable on low res
      # libre-franklin
      # noto-fonts-cjk-sans
      #################### Mono Fonts ####################
      # fira-code # Great mono with ligatures & icons
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      #################### Fonts Packages ####################
      # liberation_ttf # Times New Roman, Arial, Courier New
      # nerdfonts # Mono fonts with lots of icons
      # noto-fonts
      #################### Symbols Fonts ####################
      lmmath # Classic font with math support
      # emojione # Emoticons
      # font-awesome # A lot of icons
      # noto-fonts-emoji # Emojies

      # TODO some packages below may suit better zsh.nix file
      # TODO some packages below may suit better default.nix file
      #################### Monitoring ####################
      # ripgrep-all
      silver-searcher # better grep
      fd # better find
      duf # global disk usage
      du-dust # disk usage of a directory
      bottom # htop alternative
      fastfetch # system info
      poppler_utils # Read PDF metadata
      mediainfo # info about audio or video
      hexyl # hex viever
      # tree

      #################### Files management ####################
      trash-cli
      sd # find & replace
      # nomino # Batch rename
      # dcfldd # more powerful dd
      testdisk # file recuperation
      restic # Efficient backup
      # fuse # TEST relevance
      exfatprogs # Tools for exfat fs
      ffmpeg # media conversion
      imagemagick # CLI image edition
      # youtube-dl # download videos from internet
      yt-dlp # download videos from internet
      ventoy-full # create bootable keys
      udiskie # auto mount USB
      # jot # Notes-graph manager
      # zk # Zettelkasten

      #################### Encryption & Network ####################
      # git-secrets # Encrypted storage in public git repo
      pass # CLI password manager
      pinentry # enter passwords
      dislocker # decrypt bitlocker
      # veracrypt # multiplatform encryption
      # cryptsetup # TEST relevance
      # wireguard-tools # TEST relevance
      # nmap # TEST relevance with below
      rustscan # scan networks
      protonvpn-cli # Free VPN service
      # signal-cli # Secure messaging
      xh # User-friendly HTTP client similar to HTTPie
      # curl # Mythic HTTP client TEST xh only

      #################### Languages helpers ####################
      typst # Document processor TODO documents Nix dev shell
      typst-lsp # Document processor LSP TODO documents Nix dev shell
      rnix-lsp # Nix LSP
      nodePackages_latest.bash-language-server # Bash LSP
      lua-language-server # Lua
      ltex-ls # Grammar language server
      nodePackages_latest.prettier # General purpose formatter
      # nodePackages_latest.markdownlint-cli2
      # marksman # Markdown
      hunspell # Natural language spell checker
      hunspellDicts.fr-any # For french
      hunspellDicts.en_US # For english
      hunspellDicts.en_GB-ise # For english
      hunspellDicts.es_ES # For spanish

      #################### Miscelaneous ####################
      # TODO refile more precisely
      # poetry # Python project manager # TODO use nix instead
      # python3 # Python # TODO USE nix instead
      pulsemixer # TUI to manage sound
      # procs # better ps
      # pulseaudio # TEST relevance
      # cachix # TEST relevance
      jmtpfs # Media transfer protocol with Android devices
      # android-file-transfer
      # android-tools # ADB & Fastboot
      # android-udev-rules
      # interception-tools # TEST relevance
      # bluetooth_battery # TEST relevance
      libnotify # Notifications management
      watchexec # Run command when file changes
      hyperfine # benchmark
      ollama # Run LLMs locally
      jq # JSON filter
      rustdesk # Remote desktop
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
    ];

    file = {
      xcompose = {
        target = ".XCompose";
        # TODO find a cleaner way to write this file
        # text = builtins.readFile ../XCompose;
        source = ../script+data/XCompose;
      };
      wallpapers = {
        target = ".wallpapers";
        source = ../script+data/wallpapers;
      };
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.11";
  };

  # TODO configure this privately
  # accounts = {
  #   calendar = { };
  #   email.accounts = {
  #     pro = {
  #       himalaya = {
  #         enable = true;
  #       };
  #     };
  #   };
  # };

  xdg.configFile = {
    onagre-theme = {
      target = "onagre/theme.scss";
      source = ../style/onagre.scss;
    };
    # onagre-config = {
    #   target = "onagre/onagre.conf";
    #   source = ../script+data/onagre.conf;
    # };
    pulsemixer = {
      target = "pulsemixer.cfg";
      source = ../script+data/pulsemixer.toml;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  services = {
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "never";
    };
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
    ripgrep.enable = true; # Better grep
    # TODO set an explorer that can open & preview every file
    xplr = {
      enable = true; # TEST which explorer is better
      extraConfig = ''
        ${builtins.readFile ../script+data/xplr.lua}
      '';
    };
    lf.enable = true; # TEST which explorer is better
    broot.enable = true; # TEST which explorer is better
    nnn.enable = true; # TEST which explorer is better
    himalaya.enable = true; # TEST CLI Mail client
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
        "x-scheme-handler/mailspring" = "Mailspring.desktop";

        "application/x-colpkg" = "anki.desktop";
        "application/x-apkg" = "anki.desktop";
        "application/x-ankiaddon" = "anki.desktop";
      };
      # associations.added = { };
    };
  };
}
