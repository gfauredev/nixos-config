{ inputs, lib, config, pkgs, ... }: {
  home = {
    programs = {
      password-store = {
        enable = true;
      };
      pandoc = {
        enable = true;
        defaults = {
          # metadata = {
          #   author = "Guilhem Fauré";
          # };
          # pdf-engine = "tectonic";
          output-file = "pandoc.pdf";
          standalone = true;
          sandbox = true;
          embed-resources = true;
          # toc-depth = 3;
          variables = {
            papersize = "a4";
            # fontfamily = "tgpagella"; # TeX font
            # mainfont = "Merriweather";
            # mainfont = "Libre Baskerville";
            # sansfont = "Inter";
            # sansfont = "FiraGO";
            # monofont = "FiraCode Nerd Font"; # Code
            # mathfont = "Latin Modern Math"; # Maths
            # geometry = "margin=2cm";
          };
        };
        # templates = {
        #   "default.latex" = ../default.latex;
        #   "report.latex" = ../report.latex;
        # };
      };
    };


    # TODO: Shells with everything related to specific activities
    packages = with pkgs; [
      # Fonts
      ## Serif
      libre-baskerville # Great, stylish serif
      merriweather # Serif readable on low res screens
      vollkorn # Great serif font
      # gelasio # Serif Georgia replacement
      # lmodern # Classic serif
      # noto-fonts-cjk-serif
      ## Sans
      fira-go # Great sans with icons
      inter # Interesting sans font
      nacelle # Helvetica replacement
      # carlito # Calibri replacement
      # merriweather-sans # Sans font readable on low res
      # libre-franklin
      # noto-fonts-cjk-sans
      ## Mono
      # fira-code # Great mono with ligatures & icons
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ## Packages
      # liberation_ttf # Times New Roman, Arial, Courier New
      # nerdfonts # Mono fonts with lots of icons
      # noto-fonts
      ## Icons & Symbols
      lmmath # Classic font with math support
      # emojione # Emoticons
      # font-awesome # A lot of icons
      # noto-fonts-emoji # Emojies

      # File management & editing
      trash-cli
      ripgrep-all
      # xplr
      silver-searcher
      exa
      fd
      fzf
      ripgrep
      duf
      du-dust
      tree
      typst # Modern typesetting engine
      sd
      # hexyl
      # nomino
      lsof
      # dcfldd
      testdisk
      restic # Efficient backup
      fuse
      # exfatprogs
      ffmpeg
      # youtube-dl # download videos from internet
      yt-dlp # download videos from internet
      poppler_utils # Read PDF metadata
      mediainfo # info about audio or video
      ventoy-full # create bootable keys
      # udiskie
      tectonic # LaTeX typesetting engine
      # broot
      # python311Packages.weasyprint # HTML to PDF
      # jot # Notes-graph manager
      # zk # Zettelkasten

      # Interfaces & Useful misc
      bottom
      neofetch
      procs
      tldr
      pulsemixer
      # pulseaudio
      imagemagick
      sshfs
      # cachix
      jmtpfs # Media transfer protocol
      # android-file-transfer
      # android-tools # ADB & Fastboot
      # android-udev-rules
      # interception-tools
      bluetooth_battery
      wine
      winetricks
      yabridge
      yabridgectl
      eva
      # dwfv
      # sonar-scanner-cli
      rsync
      acpi
      usbutils
      pciutils
      lm_sensors
      # powertop
      wakelan
      inetutils
      # mongosh
      # mongodb-tools
      # mongoaudit
      # arduino-core # Arduino from CLI
      # arduino-cli # Arduino from CLI
      # minicom # Serial
      libnotify # Notifications management
      watchexec # Run command when file changes
      plantuml-c4 # UML diagrams
      # zola # Static site generator
      # hugo # Static site generator
      # spotify-tui
      # khal # Calendar compatible with WebCal
      # entr # Run command when file changes
      # cpulimit
      # undervolt
      # cpufrequtils
      # bftpd
      # zenith
      # crosvm
      # firecracker
      # doxygen
      # pcscliteWithPolkit
      # mdds
      # firectl
      # ignite
      # kubernetes

      # Encryption & Network
      # git-secrets # Encrypted storage in public git repo
      # pass # Minimal password manager
      # pinentry
      veracrypt
      dislocker
      qbittorrent-nox
      # wireguard-tools
      # ciscoPacketTracer8 # Network simulation
      # cryptsetup
      # nmap
      # websocat
      # rustscan
      # gobuster
      # httrack
      # tshark
      # termshark
      curl # Mythic HTTP client
      xh # User-friendly HTTP client similar to HTTPie
      protonvpn-cli # Free VPN service
      signal-cli # Secure messaging
      # wget
      # httpie
      # netcat
      # netcat-openbsd
      # udptunnel

      # Language servers & Linters & Correcters
      ## Script 
      # nodePackages_latest.bash-language-server # Bash
      # rnix-lsp # Nix
      # lua-language-server # Lua
      # nodePackages_latest.pyright # Python linter & type checker
      # ruff # Fast Python linter
      # python311Packages.ruff-lsp # LSP for Ruff
      # black # Better Python formatter
      # isort # Python import sorter
      ## Web
      # nodePackages_latest.vscode-langservers-extracted # Web
      # nodePackages_latest.typescript-language-server # Typescript
      ## Low level
      # rust-analyzer
      # arduino-language-server # Arduino lsp
      # ccls # C/C++ language server
      ## Misc
      # sqls # Language server
      # java-language-server

      # Natural language & Lightweight markup spelling
      # python311Packages.googletrans # Google Translate API
      typst-lsp # Typesetting system language server
      # typst-fmt # Typesetting system formatter
      ltex-ls # Grammar language server
      # nodePackages_latest.markdownlint-cli2
      # marksman # Markdown
      hunspell
      hunspellDicts.fr-any
      hunspellDicts.en_US
      hunspellDicts.en_GB-ise
      hunspellDicts.es_ES

      # Compilers & Runtimes & Package managers & Misc
      # nodePackages_latest.typescript # Typescript compiler
      # nodejs # JS runtime
      # bun # Faster JS runtime
      # nodePackages_latest.pnpm # Better JS package manager
      # python3Full # Python runtime
      # poetry # Python package & dependency manager + build system
      # virtualenv # Python isolated environments
      # pypy3 # Faster Python runtime
      # python311Packages.pip # Python package manager
      # python311Packages.ipython # Better Python REPL
      # python311Packages.venvShellHook # Python virtual env Nix
      # nodePackages_latest.html-minifier
      # nodePackages_latest.prettier
      # go # The go compiler

      # Pentesting & Benchmarking
      # aircrack-ng
      # john
      # thc-hydra
      # sn0int
      # maigret
      # sqlmap
      # mitmproxy
      # hyperfine
      # wireshark
      # metasploit
      # zap
      # burpsuite # PROPRIETARY pentesting tool
    ];
  };
}
