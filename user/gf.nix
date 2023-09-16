{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./zsh.nix # Shell config
  ];

  nixpkgs = {
    overlays = [
      # use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "gf";
    homeDirectory = "/home/gf";

    sessionVariables = lib.mkDefault {
      XDG_DESKTOP_DIR = "$HOME";
      XDG_DOCUMENTS_DIR = "$HOME/doc";
      XDG_DOWNLOAD_DIR = "$HOME/dl";
      XDG_MUSIC_DIR = "$HOME/audio";
      XDG_PICTURES_DIR = "$HOME/img";
      XDG_VIDEOS_DIR = "$HOME/vid";
      XDG_CONFIG_HOME = "$HOME/.config";

      # EDITOR = "nvim"; TODO: test pertinence
      # BROWSER = "brave";
      # VISUAL = "nvim";
      # TERMINAL = "wezterm";
      # TERM = "wezterm";

      # PNPM_HOME = "$HOME/.local/share/pnpm"; TODO: test pertinence
      # TYPST_FONT_PATHS = "$HOME/.nix-profile/share/fonts";
      # TYPST_ROOT = "$HOME/.local/share/typst";
    };

    packages = with pkgs; [
      #################### Serif Fonts ####################
      libre-baskerville # Great, stylish serif
      merriweather # Serif readable on low res screens
      vollkorn # Great serif font
      # gelasio # Serif Georgia replacement
      # lmodern # Classic serif
      # noto-fonts-cjk-serif
      #################### Sans Fonts ####################
      fira-go # Great sans with icons
      inter # Interesting sans font
      nacelle # Helvetica replacement
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
      exa # ls replacement
      # ripgrep-all
      silver-searcher
      fd
      duf # global disk usage
      du-dust # disk usage of a directory
      bottom # htop alternative
      neofetch
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
      ffmpeg
      # youtube-dl # download videos from internet
      yt-dlp # download videos from internet
      ventoy-full # create bootable keys
      # udiskie # auto mount USB
      # jot # Notes-graph manager
      # zk # Zettelkasten

      #################### Encryption & Network ####################
      # git-secrets # Encrypted storage in public git repo
      pass # Minimal password manager
      pinentry # enter passwords
      veracrypt
      dislocker # decrypt bitlocker
      # cryptsetup # TEST relevance
      # wireguard-tools
      # nmap # TEST relevance with below
      rustscan # scan networks
      protonvpn-cli # Free VPN service
      signal-cli # Secure messaging
      xh # User-friendly HTTP client similar to HTTPie
      # curl # Mythic HTTP client TEST xh only

      #################### Languages helpers ####################
      rnix-lsp # Nix
      nodePackages_latest.bash-language-server # Bash
      ltex-ls # Grammar language server
      # nodePackages_latest.markdownlint-cli2
      # marksman # Markdown
      hunspell
      hunspellDicts.fr-any
      hunspellDicts.en_US
      hunspellDicts.en_GB-ise
      hunspellDicts.es_ES

      #################### Miscelaneous ####################
      # TODO refile more precisely
      tldr
      pulsemixer
      imagemagick # image edit
      sshfs
      rsync
      # procs # better ps
      # pulseaudio # TEST relevance
      # cachix # TEST relevance
      jmtpfs # Media transfer protocol
      # android-file-transfer
      # android-tools # ADB & Fastboot
      # android-udev-rules
      # interception-tools # TEST relevance
      # bluetooth_battery # TEST relevance
      wine # Execute Window$ programs
      winetricks # Execute Window$ programs
      acpi
      usbutils # lsusb
      pciutils # lspci
      lm_sensors # get temps
      wakelan
      libnotify # Notifications management
      watchexec # Run command when file changes
      hyperfine # benchmark
      # eva
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

    services = {
      udiskie = {
        enable = true;
        automount = true;
        notify = true;
        tray = "never";
      };
      syncthing = {
        enable = true;
      };
      # System-wide text expander
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
      ripgrep.enable = true;
      # TODO set an explorer that can open & preview every file
      broot.enable = true; # TEST which is better
      xplr.enable = true; # TEST which is better
      nnn.enable = true; # TEST which is better
      fzf.enable = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
