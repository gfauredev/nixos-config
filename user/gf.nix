{ inputs, lib, config, pkgs, ... }: {
  nixpkgs = {
    # overlays = [ ];
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
      XDG_CONFIG_HOME = "$HOME/.config";

      BROWSER = "brave";
      TERMINAL = "wezterm";
      TERM = "wezterm"; # TEST pertinence

      # EDITOR = "nvim"; # TEST pertinence
      # VISUAL = "nvim"; # TEST pertinence

      # PNPM_HOME = "$HOME/.local/share/pnpm"; TEST pertinence
      # TYPST_FONT_PATHS = "$HOME/.nix-profile/share/fonts";
      # TYPST_ROOT = "$HOME/.local/share/typst";
    };

    packages = with pkgs; [
      #################### Serif Fonts ####################
      libre-baskerville # Great, stylish serif
      merriweather # Serif readable on low res screens
      # vollkorn # Great serif font
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
      #################### Monitoring ####################
      eza # ls replacement (exa fork)
      # exa # unmaintained ls replacement
      # ripgrep-all
      silver-searcher # better grep
      fd # better find
      duf # global disk usage
      du-dust # disk usage of a directory
      bottom # htop alternative
      neofetch # system info
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
      # udiskie # auto mount USB
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
      signal-cli # Secure messaging
      xh # User-friendly HTTP client similar to HTTPie
      # curl # Mythic HTTP client TEST xh only

      #################### Languages helpers ####################
      rnix-lsp # Nix LSP
      nodePackages_latest.bash-language-server # Bash LSP
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
        source = ../XCompose;
      };
      bg0 = {
        target = ".bg0";
        source = ../bg0.jpg;
      };
      bg1 = {
        target = ".bg1";
        source = ../bg1.jpg;
      };
      bg2 = {
        target = ".bg2";
        source = ../bg2.jpg;
      };
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.11";
  };

  xdg.configFile = {
    pulsemixer = {
      target = "pulsemixer.cfg";
      # TODO find a cleaner way to write this TOML config file
      source = ../pulsemixer.toml;
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
    broot.enable = true; # TEST which is better
    xplr.enable = true; # TEST which is better
    nnn.enable = true; # TEST which is better
    # fzf.enable = true; # Fuzzy search
  };
}
