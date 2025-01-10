{ pkgs, lib, ... }: { # Useful programs TODO organize better
  imports = [ ./alacritty ./wezterm ./ghostty ./neovim ./helix ./pulsemixer ];

  home.packages = with pkgs; [
    # Theme & Style
    # libsForQt5.qt5ct # TEST if relevant
    # libsForQt5.qtstyleplugin-kvantum # TEST if relevant
    # libsForQt5.qt5.qtwayland # TEST if relevant
    # qt6Packages.qt6ct # TEST if relevant
    # qt6Packages.qtstyleplugin-kvantum # TEST if relevant
    # qt6.qtwayland # TEST if relevant
    # libsForQt5.systemsettings # TEST if relevant
    # adwaita-qt # TEST if relevant
    # gsettitngs-qt # GTK Settings
    # asciiquarium-transparent # Best screensaver ever, to install declaratively
    # cmatrix # Simulate falling text as in matrix, to install declaratively

    # Cleaning & Desktop monitoring
    # czkawka # Modern cleaner
    # bleachbit # Good old cleaner
    # stacer # Modern cleaner & monitoring

    # AI Tools
    ollama # Run LLMs locally
    # aichat # (Local) LLM in the terminal
    # jan # Run LLMs locally
    # open-interpreter # Interpret LLM code in terminal directly

    # Storage & Backup
    restic # Efficient backup tool
    ventoy-full # create bootable keys
    testdisk # file recuperation
    # tmsu # File tagging with virtual FS
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
        default_flags = "dgps";
        special_paths = lib.mkForce { };
      };
    };
    yazi = {
      enable = true; # TODO configure
      #   keymap = {
      #     input.prepend_keymap = [
      #       {
      #         run = "close";
      #         on = [ "<C-q>" ];
      #       }
      #       {
      #         run = "close --submit";
      #         on = [ "<Enter>" ];
      #       }
      #       {
      #         run = "escape";
      #         on = [ "<Esc>" ];
      #       }
      #       {
      #         run = "backspace";
      #         on = [ "<Backspace>" ];
      #       }
      #     ];
      #     manager.prepend_keymap = [
      #       {
      #         run = "escape";
      #         on = [ "<Esc>" ];
      #       }
      #       {
      #         run = "quit";
      #         on = [ "q" ];
      #       }
      #       {
      #         run = "close";
      #         on = [ "<C-q>" ];
      #       }
      #     ];
      #   };
    };
    translate-shell.enable = true;
  };
}
