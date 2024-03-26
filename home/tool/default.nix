# Useful programs TODO organize better
{ pkgs, ... }: {
  imports = [ ./wezterm ./alacritty ./neovim ./pulsemixer ];

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
    # glib # GTK Tools
    # gsettitngs-qt # GTK Settings
    # asciiquarium-transparent # Best screensaver ever
    # cmatrix # Simulate falling text as in matrix

    # Cleaning & Desktop monitoring
    # bleachbit # Good old cleaner
    # czkawka # Modern cleaner
    # stacer # Modern cleaner & monitoring

    # LSP & Formatter
    nil # Nix LSP
    nixfmt # Nix formatter
    nodePackages_latest.bash-language-server # Bash LSP
    lua-language-server # Lua LSP
    dprint # Pluggable code formatting platform

    # AI Tools
    ollama # Run LLMs locally
    jan # Run LLMs locally
    # open-interpreter # Interpret LLM code in terminal directly

    # Misc
    udiskie # auto mount USB
    restic # Efficient backup tool
    ventoy-full # create bootable keys
    testdisk # file recuperation
    # dcfldd # more powerful dd
    watchexec # Run command when file changes
    hyperfine # Benchmark commands
    jq # JSON filter
    # rpi-imager # Raspberry Pi OS generator
    valent # kdeconnect protocol (bilateral Android remote control)

    # Virtualization
    vagrant # VM auto provisionner
    virt-manager # GUI frontend to libvirtd
    # looking-glass-client
    # kubernetes # Container orchestrator

    # Miscelaneous
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
    # eva # Evaluate math expression
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
      settings = {
        # modal = true;
        default_flags = "dgps";
      };
    };
  };
}
