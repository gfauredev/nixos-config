{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  programs.home-manager.enable = true; # MANDATORY
  news.display = "notify"; # Notify for new home manager options
  nix.package = pkgs.nix;
  nix.settings = {
    max-jobs = lib.mkDefault 4; # Never start more than 16 processes
    cores = lib.mkDefault 4; # Never start more than 16 processes
  };
  manual = {
    html.enable = true;
    json.enable = true;
    manpages.enable = true;
  };

  imports = [
    ./options.nix # Homes default options
    ./module/shell # Interactive POSIX shell(s)
    ./module/terminal # Terminal emulators
    ./module/editor # CLI and GUI text editors
    ./module/remap # Ergonomy
    ./module/launcher # Quick keyboard launcher(s)
    ./module/agent # AI Agents config
  ];

  home = {
    username = config.user.name;
    homeDirectory = config.user.home;
    sessionVariables = {
      XDG_DESKTOP_DIR = config.user.home;
      XDG_DOCUMENTS_DIR = "${config.user.home}/collect";
      XDG_MUSIC_DIR = "${config.user.home}/collect";
      XDG_PICTURES_DIR = "${config.user.home}/image";
      XDG_VIDEOS_DIR = "${config.user.home}/image";
      XDG_DOWNLOAD_DIR = "${config.user.home}/tmp";
      XDG_PUBLICSHARE_DIR = "${config.user.home}/tmp";
      CARAPACE_BRIDGES = "inshellisense,fish,zsh,bash";
    };
    file = {
      tmp.source = config.lib.file.mkOutOfStoreSymlink "/run/user/1000"; # TODO Parametric user number, or elsewhere writable temporary
      # Downloads.source = config.lib.file.mkOutOfStoreSymlink config.home.sessionVariables.XDG_DOWNLOAD_DIR; # for reluctant apps…
      # Documents.source = config.lib.file.mkOutOfStoreSymlink config.home.sessionVariables.XDG_DOCUMENTS_DIR;
    };
    enableNixpkgsReleaseCheck = true; # May become annoying around releases
  };

  xdg = {
    enable = true;
    portal.enable = true;
    mime.enable = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications =
      let
        video = "mpv";
        image = "mpv";
        audio = "mpv";
      in
      {
        # Text & Code
        "text/plain" = "${config.editor.desktop}.desktop";
        "text/markdown" = "${config.editor.desktop}.desktop";
        "text/code" = "${config.editor.desktop}.desktop";
        # "inode/directory" = "${term}.desktop"; # Use broot ?
        # Document (Open)
        "application/vnd.oasis.opendocument.text" = "writer.desktop";
        "application/vnd.oasis.opendocument.spreadsheet" = "calc.desktop";
        "application/vnd.oasis.opendocument.presentation" = "impress.desktop";
        "application/vnd.oasis.opendocument.graphics" = "draw.desktop";
        "application/vnd.oasis.opendocument.chart" = "calc.desktop";
        "application/vnd.oasis.opendocument.formula" = "math.desktop";
        "application/vnd.oasis.opendocument.image" = "draw.desktop";
        # Document
        "application/msword" = "onlyoffice-desktopeditors.desktop";
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
          "onlyoffice-desktopeditors.desktop";
        "application/vnd.ms-excel" = "onlyoffice-desktopeditors.desktop";
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" =
          "onlyoffice-desktopeditors.desktop";
        "application/vnd.ms-powerpoint" = "onlyoffice-desktopeditors.desktop";
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" =
          "onlyoffice-desktopeditors.desktop";
        "application/pdf" = "${config.browser.entry}.desktop";
        # Image
        "image/avif" = "${image}.desktop";
        "image/webp" = "${image}.desktop";
        "image/png" = "${image}.desktop";
        "image/jpg" = "${image}.desktop";
        "image/jpeg" = "${image}.desktop";
        "image/bmp" = "${image}.desktop";
        "image/ico" = "${image}.desktop";
        "image/gif" = "${image}.desktop";
        # Audio
        "audio/flac" = "${audio}.desktop";
        "audio/ogg" = "${audio}.desktop";
        "audio/wav" = "${audio}.desktop";
        "audio/mp3" = "${audio}.desktop";
        # Video
        "video/mkv" = "${video}.desktop";
        "video/mp4" = "${video}.desktop";
        "video/avi" = "${video}.desktop";
        # Web
        "x-scheme-handler/https" = "${config.browser.entry}.desktop";
        "x-scheme-handler/http" = "${config.browser.entry}.desktop";
        # Email & Calendar
        "x-scheme-handler/net.thunderbird" = "thunderbird.desktop";
        "x-scheme-handler/mailto" = "${config.organization.email.entry}.desktop";
        "x-scheme-handler/webcal" = "${config.organization.calendar.entry}.desktop";
        "x-scheme-handler/webcals" = "${config.organization.calendar.entry}.desktop";
        "application/x-extension-ics" = "${config.organization.calendar.entry}.desktop";
        "text/calendar" = "${config.organization.calendar.entry}.desktop";
        # "x-scheme-handler/mid" = "?.desktop";
        # "x-scheme-handler/news" = "?.desktop";
        # "x-scheme-handler/snews" = "?.desktop";
        # "x-scheme-handler/nntp" = "?.desktop";
        # "x-scheme-handler/feed" = "?.desktop";
        # "application/rss+xml" = "?.desktop";
        # "application/x-extension-rss" = "?.desktop";
        # App Specific
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
        "application/x-colpkg" = "anki.desktop";
        "application/x-apkg" = "anki.desktop";
        "application/x-ankiaddon" = "anki.desktop";
        "x-scheme-handler/appflowy-flutter" = "appflowy.desktop";
      };
    portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    portal.config.common.default = [
      "hyprland"
      "gtk"
    ];
    # portal.xdgOpenUsePortal = true; # Always prompt for which app to use
    configFile = {
      "ltex/fr.dict".source = config.lib.file.mkOutOfStoreSymlink "${config.location}/home/ltex/fr.dict";
      "ltex/en-GB.dict".source =
        config.lib.file.mkOutOfStoreSymlink "${config.location}/home/ltex/en.dict";
      "ltex/en-US.dict".source =
        config.lib.file.mkOutOfStoreSymlink "${config.location}/home/ltex/en.dict";
    };
  };

  stylix = {
    enable = true; # Manage all things style & appearance
    polarity = "dark";
    fonts = {
      serif = {
        package = pkgs.libertinus;
        name = "Libertinus Serif";
      };
      sansSerif = {
        package = pkgs.aileron;
        name = "Aileron";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.nerd-fonts.symbols-only;
        name = "Symbols Nerd Font";
      };
    };
    # Based on Catppuccin Mocha, but with pitch black #000 background for OLED, https://catppuccin.com/palette
    base16Scheme = {
      base00 = "#000000"; # base00 = "#1e1e2e"; # pitch black, default background
      base01 = "#181825"; # mantle, alternate background
      base02 = "#313244"; # surface0, selection background
      base03 = "#45475a"; # surface1
      base04 = "#585b70"; # surface2, alternate text
      base05 = "#cdd6f4"; # text, default text
      base06 = "#f5e0dc"; # rosewater
      base07 = "#b4befe"; # lavender
      base08 = "#f38ba8"; # red, error
      base09 = "#fab387"; # peach, urgent
      base0A = "#f9e2af"; # yellow, warning
      base0B = "#a6e3a1"; # green
      base0C = "#94e2d5"; # teal
      base0D = "#89b4fa"; # blue
      base0E = "#cba6f7"; # mauve
      base0F = "#f2cdcd"; # flamingo
      # Added based on Helix’s Catppuccin Mocha theme
      base10 = "#f5c2e7"; # pink
      base11 = "#eba0ac"; # maroon
      base12 = "#89dceb"; # sky
      base13 = "#74c7ec"; # sapphire
      base14 = "#bac2de"; # subtext1
      base15 = "#a6adc8"; # subtext0
      base16 = "#9399b2"; # overlay2
      base17 = "#7f849c"; # overlay1
      base18 = "#6c7086"; # overlay0
      base19 = "#11111b"; # crust
      # Additional
      base1A = "#2a2b3c"; # cursorline
      base1B = "#b5a6a8"; # secondary_cursor
      base1C = "#878ec0"; # secondary_cursor_normal
      base1D = "#7ea87f"; # secondary_cursor_insert
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };
    targets.helix.enable = false; # FIXME ugly looking with treesitter, https://github.com/chriskempson/base16/blob/main/styling.md
    targets.firefox.enable = false; # FIXME infinite recursion bug TODO style
  };

  home.packages =
    with pkgs;
    [
      klick # Metronome
      cheese # Webcam capture
      pre-commit # Git hook manager
      fuc # Perf cpz rmz
      scc # Better alternative to cloc for counting lines of code
      adwaita-icon-theme # Icons for GTK
      nixpkgs-review # Quickly review pull requests to nixpkgs
      watchexec # Run command when file changes
      hyperfine # Benchmark commands
      commitlint-rs # Be consistent in commit messages
      android-tools # ADB and Fastboot
      worktrunk # Git worktree management
      bottles # Easier wine management
    ] # Passwords & Secrets
    ++ [
      pkgs-unstable.proton-pass # Proton password manager
      pkgs-unstable.proton-authenticator # Proton 2FA
      gitleaks # Better tool to discover secrets in Git repo TODO Auto for config
      git-filter-repo # Quickly rewrite history
    ] # Storage & Backup & Encryption
    ++ [
      restic # Efficient backup tool
      rustic # Restic compatible pure Rust backup tool TEST me
      testdisk # Recover deleted files
      exfatprogs # Tools for exfat FS
      smartmontools # Monitor health of drives
      android-file-transfer # Media Transfer Protocol (Android…)
      (pkgs.callPackage ./module/protonDrive.nix { })
      imagemagick # CLI image edition
      mediainfo # info about audio or video
      pkgs-unstable._7zz-rar
      localsend # Share files on local network
    ] # NLP
    ++ [
      pkgs-unstable.opencode # Any LLM Open Source Agent CLI
      pkgs-unstable.goose-cli # TEST
      pkgs-unstable.openspec # TEST
      pkgs-unstable.open-interpreter # TEST
      pkgs-unstable.pi-coding-agent # TEST
      pkgs-unstable.whale # TEST
      pkgs-unstable.llama-cpp
      pkgs-unstable.whisper-cpp # STT
      ltex-ls-plus # Text grammar checker LSP using Languagetool (Java, slow)
    ] # Engineering & Electronics
    ++ [
      dfu-util # Device Firmware Upgrade USB utility
      rpi-imager # Raspberry Pi OS imager
      kicad # Electronics (EDA) software
      ngspice # Electronic circuit simulator
      qucs-s # Electronics simulations
      freecad-wayland # Popular parametric 3D CAD
      orca-slicer # G-code generator for 3D printers…
      # pkgs-unstable.openscad-unstable # Code CAD
      # pkgs-unstable.openscad-lsp # LSP
    ] # VPN
    ++ [
      pkgs-unstable.proton-vpn # Swiss VPN service (Python GUI)
      pkgs-unstable.proton-vpn-cli # Swiss VPN service (CLI)
      pkgs-unstable.nym # Super-anonymous routing protocol FIXME lacks desktop apps
      mullvad # Anonymous VPN service (CLI)
      mullvad-vpn # Anonymous VPN service (GUI)
    ] # Messaging & Social
    ++ [
      pkgs-unstable.signal-cli # Secure messaging
      pkgs-unstable.signal-desktop # Secure messaging
      sherlock # Search people on social media accounts
      maigret # Search people on social media accounts
    ];

  services = {
    syncthing.enable = true; # Efficient P2P Syncing
    dunst.enable = true; # Notifications daemon
    gpg-agent.enable = true; # Keeps your gpg key loaded
    podman.enable = true; # Containerization for development and more
    syncthing = {
      overrideDevices = lib.mkDefault true; # No imperative config
      overrideFolders = lib.mkDefault true; # No imperative config
      settings = {
        options.relaysEnabled = true;
        options.localAnnounceEnabled = true;
      };
    };
    dunst.settings.global = {
      timeout = "6s";
      origin = "bottom-right";
      offset = "0x-28"; # Lowered to align with status bar
      frame_width = 0; # No borders
      corner_radius = 12; # Rounded corners
    };
    # podman.settings.containers.containers.userns = "keep-id"; FIX
    gpg-agent.pinentry.package = pkgs.pinentry-qt; # pkgs.pinentry-gnome3;
  };

  programs = {
    git.enable = true; # MANDATORY
    direnv.enable = true; # Auto load nix shell when cd
    gpg.enable = true; # Useful cryptography tool
    jujutsu.enable = true; # Git compatible simpler VCS
    mergiraf.enable = true; # Smart Git merge tool
    rclone.enable = true; # Backup using cloud services
    delta.enable = true; # Better diff view (integrates with Git)
    # radicle.enable = true; # Decentralized code collaboration
    password-store.enable = true;
    mergiraf = {
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
    };
    git = {
      lfs.enable = true;
      # attributes = ["* merge=mergiraf"];
      ignores = [
        "*.ignore"
        "*.ignore.*"
      ];
      settings = {
        user.email = config.user.email;
        user.name = config.user.description;
        init.defaultBranch = "main";
        pull.rebase = true;
        fetch.prune = true;
        fetch.pruneTags = true;
        push.autoSetupRemote = true;
        push.followTags = true;
        lfs.locksverify = true;
        diff.algorithm = "histogram";
        diff.colorMoved = "plain";
        diff.mnemonicPrefix = true;
        submodule = {
          recurse = true;
          fetchjobs = 8;
        };
        credential.helper = "cache 36000"; # Cache for 10 hours
        # filter.lfs = {
        #   required = true;
        #   clean = "git-lfs clean -- %f";
        #   smudge = "git-lfs smudge -- %f";
        #   process = "git-lfs filter-process";
        # };
        merge.conflictstyle = "zdiff3";
      };
      settings.alias = {
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      };
    };
    delta = {
      enableGitIntegration = true;
      options.navigate = true;
      # options.side-by-side = true;
    };
    jujutsu.settings.user = {
      name = config.user.description;
      email = config.user.email;
    };
    direnv.nix-direnv.enable = true;
    password-store.settings.PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
  };

  gtk = {
    enable = true; # Remove this from $HOME
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/settings";
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = 1";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };
  qt.enable = true;
}
