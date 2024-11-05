# Useful programs TODO organize better
{ pkgs, ... }: {
  imports = [ ./wezterm ./alacritty ./neovim ./helix ./zed ./pulsemixer ];

  home.packages = with pkgs; [
    # Theme & Style
    # libsForQt5.qt5ct # TEST if relevant
    libsForQt5.qtstyleplugin-kvantum # TEST if relevant
    # libsForQt5.qt5.qtwayland # TEST if relevant
    # qt6Packages.qt6ct # TEST if relevant
    qt6Packages.qtstyleplugin-kvantum # TEST if relevant
    # qt6.qtwayland # TEST if relevant
    # libsForQt5.systemsettings # TEST if relevant
    # adwaita-qt # TEST if relevant
    # gsettitngs-qt # GTK Settings
    asciiquarium-transparent # Best screensaver ever
    cmatrix # Simulate falling text as in matrix

    # Cleaning & Desktop monitoring
    czkawka # Modern cleaner
    # bleachbit # Good old cleaner
    # stacer # Modern cleaner & monitoring

    # LSP & Formatter
    # tree-sitter # Parser generator tool and library
    # (pkgs.tree-sitter.withPlugins
    #   (p: [ p.tree-sitter-c p.tree-sitter-typescript ]))
    # (pkgs.tree-sitter.withPlugins (_: allGrammars))
    nil # Nix LSP
    nixfmt # Nix formatter
    nickel # Configuration generation language
    nls # Nickel LSP
    explain # Explain system call errors
    shellcheck # Shell script analysis
    shfmt # Shell script formatter
    bash-language-server # Bash LSP
    lua-language-server # Lua LSP
    vscode-langservers-extracted # HTML/CSS/JSON/ESLint
    # nodePackages_latest.vscode-json-languageserver # JSON LSP
    yaml-language-server # YAML LSP
    taplo # TOML LSP and toolkit
    dprint # Pluggable code formatting platform
    lsp-ai # Language server for language models

    # AI Tools
    ollama # Run LLMs locally
    jan # Run LLMs locally
    # open-interpreter # Interpret LLM code in terminal directly

    # Storage & Backup
    restic # Efficient backup tool
    ventoy-full # create bootable keys
    testdisk # file recuperation
    tmsu # File tagging with virtual FS
    iroh # Efficient IPFS, p2p file sharing
    # sendme # send files and directories p2p
    # udiskie # auto mount USB
    # dcfldd # more powerful dd
    # rpi-imager # Raspberry Pi OS generator

    # Virtualization
    # vagrant # VM auto provisionner TODO reenable
    virt-manager # GUI frontend to libvirtd
    # looking-glass-client
    # kubernetes # Container orchestrator

    # Miscellaneous
    jq # JSON parsing and request tool USED BY HYPRLAND CONFIG
    kalker # Evaluate math expression
    watchexec # Run command when file changes
    hyperfine # Benchmark commands
    # valent # kdeconnect protocol (bilateral Android remote control)
    # poetry # Python project manager # TODO use nix instead
    # python3 # Python # TODO USE nix instead
    # conda # Python package manager TODO flake shell
    # procs # better ps
    # cachix # TEST relevance
    # android-file-transfer
    # android-tools # ADB & Fastboot
    # android-udev-rules
    # interception-tools # TEST relevance
    # bluetooth_battery # TEST relevance
    # rustdesk # Remote desktop
    # dwfv
    # inetutils
    # khal # Calendar compatible with WebCal
    # entr # Run command when file changes
    # cpulimit
    # undervolt
    # cpufrequtils
    # pcscliteWithPolkit
  ];

  services = {
    syncthing = {
      enable = true;
      extraOptions = [ "--no-default-folder" ];
    };
  };

  programs = {
    broot = {
      enable = true; # Quick fuzzy file finder
      enableZshIntegration = true;
      enableNushellIntegration = true;
      settings = {
        # modal = true;
        default_flags = "dgps";
      };
    };
  };
}
