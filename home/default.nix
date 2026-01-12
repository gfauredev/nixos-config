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
  nix.settings.max-jobs = 12; # Limit threads usage of nix builds
  nix.package = pkgs.nix;
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
  ];

  home = {
    username = config.user.name;
    homeDirectory = config.user.home;
    sessionVariables = {
      XDG_DESKTOP_DIR = config.user.home;
      XDG_DOCUMENTS_DIR = "${config.user.home}/data";
      XDG_MUSIC_DIR = "${config.user.home}/data";
      XDG_PICTURES_DIR = "${config.user.home}/image";
      XDG_VIDEOS_DIR = "${config.user.home}/image";
      XDG_DOWNLOAD_DIR = "${config.user.home}/tmp";
      XDG_PUBLICSHARE_DIR = "${config.user.home}/tmp";
      CODE_DIR = "${config.user.home}/dev";
    };
    file = {
      Downloads.source = config.lib.file.mkOutOfStoreSymlink config.home.sessionVariables.XDG_DOWNLOAD_DIR; # for reluctant apps…
      # Documents.source = config.lib.file.mkOutOfStoreSymlink config.home.sessionVariables.XDG_DOCUMENTS_DIR;
    };
    enableNixpkgsReleaseCheck = true; # May become annoying around releases
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications =
      let
        image = "qimgv";
        audio = "mpv";
        video = "mpv";
        web = config.browser.desktop;
        pdf = web; # "org.pwmt.zathura";
        document = "writer";
        spreadsheet = "calc";
        pim = config.organization.pim;
      in
      {
        # Text & Code
        "text/plain" = "${config.editor.desktop}.desktop";
        "text/markdown" = "${config.editor.desktop}.desktop";
        "text/code" = "${config.editor.desktop}.desktop";
        # "inode/directory" = "${term}.desktop"; # Use broot ?
        # Document
        "application/vnd.oasis.opendocument.text" = "${document}.desktop";
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "${spreadsheet}.desktop";
        "application/vnd.ms-excel" = "${spreadsheet}.desktop";
        "application/pdf" = "${pdf}.desktop";
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
        "x-scheme-handler/https" = "${web}.desktop";
        "x-scheme-handler/http" = "${web}.desktop";
        # Email & Calendar
        "x-scheme-handler/mailto" = "${pim}.desktop";
        "x-scheme-handler/webcal" = "${pim}.desktop";
        "x-scheme-handler/webcals" = "${pim}.desktop";
        "x-scheme-handler/mid" = "${pim}.desktop";
        "x-scheme-handler/news" = "${pim}.desktop";
        "x-scheme-handler/snews" = "${pim}.desktop";
        "x-scheme-handler/nntp" = "${pim}.desktop";
        "x-scheme-handler/feed" = "${pim}.desktop";
        "application/rss+xml" = "${pim}.desktop";
        "application/x-extension-rss" = "${pim}.desktop";
        "application/x-extension-ics" = "${pim}.desktop";
        "text/calender" = "${pim}.desktop";
        # App Specific
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
        "application/x-colpkg" = "anki.desktop";
        "application/x-apkg" = "anki.desktop";
        "application/x-ankiaddon" = "anki.desktop";
        "x-scheme-handler/appflowy-flutter" = "appflowy.desktop";
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

  home.packages = with pkgs; [
    mediainfo # info about audio or video
    # exercism # CLI for the programming exercises website
    # localsend # Share files on local network
    # captive-browser # Browser for captive portals
    adwaita-icon-theme # Icons for GTK
    nixpkgs-review # Quickly review pull requests to nixpkgs
    watchexec # Run command when file changes
    hyperfine # Benchmark commands
    nickel # Modern configuration Nickel, Nix improvement
    commitlint-rs # Be consistent in commit messages
    # kalker # Evaluate math expression
    # comma # Run any command from Nixpkgs
    # Passwords & Secrets
    pkgs-unstable.proton-pass # Proton password manager
    # bitwarden-cli # Modern password manager, replaced by rbw
    # bitwarden-desktop
    # keepassxc # Password manager
    # keepassxc-go # CLI to interacet with KeepassXC
    # git-credential-keepassxc # Use KeepassXC with Git
    gitleaks # Better tool to discover secrets in Git repo TODO Auto for config
    git-filter-repo # Quickly rewrite history
    # Storage & Backup & Encryption
    restic # Efficient backup tool
    rustic # Restic compatible pure Rust backup tool TEST me
    # ventoy-full # Create bootable keys FIX disable as insecure/closed source blobs
    testdisk # Recover deleted files
    exfatprogs # Tools for exfat FS
    smartmontools # Monitor health of drives
    jmtpfs # Media transfer protocol with Android devices
    # dislocker # Decrypt BitLocker disks
    # cdrkit # ISO tools and misc
    # Emulation & Compatibility
    bottles # Easier wine management
    # quickemu # Quickly create optimized VMs
    # lima # Quickly create optimized VMs
    # wine # Execute Window$ programs
    # wineWowPackages.stable # Execute Window$ programs (32 and 64 bits)
    # wineWowPackages.waylandFull # Execute Window$ programs (32 and 64 bits)
    # winetricks # Execute Window$ programs (config tool)
    # Machine learning & AI
    gemini-cli # Google Gemini CLI
    copilot-cli # GitHub Copilot CLI
    # llama-cpp # Large language model server
    # gpt4all # -cuda # TEST
    # aichat # CLI LLM chat
  ];

  services = {
    syncthing.enable = true; # Efficient P2P Syncing
    # restic.enable = true; # Efficient backup tool TEST service instead of CLI
    dunst.enable = true; # Notifications daemon
    gpg-agent.enable = true; # Keeps your gpg key loaded
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
    # radicle.enable = true; # Decentralized code collaboration TODO 25.11
    git = {
      lfs.enable = true;
      attributes = [
        "* merge=mergiraf"
      ];
      ignores = [
        "*ignore*"
        "!.gitignore"
      ];
      # hooks.pre-commit = pkgs.writeShellScript "git-pre-commit" '' # FIX Prevents LFS to install
      #   set -e # Exit immediately on error
      #   gitleaks dir --config ${./module/gitleaks.toml} --max-target-megabytes 1 --verbose # --redact
      # '';
      settings = {
        user.email = config.user.email;
        user.name = config.user.description;
        init.defaultBranch = "main";
        pull.rebase = false;
        lfs.locksverify = true;
        submodule = {
          recurse = true;
          fetchjobs = 8;
        };
        credential.helper = "cache 36000"; # Cache for 10 hours
        filter.lfs = {
          required = true;
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
        };
        merge.conflictstyle = "diff3";
      };
    };
    jujutsu.settings.user = {
      name = config.user.description;
      email = config.user.email;
    };
    direnv.nix-direnv.enable = true;
    delta = {
      enableGitIntegration = true;
      options.navigate = true;
    };
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
