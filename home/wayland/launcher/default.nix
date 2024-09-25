{ pkgs, term, ... }: {
  # imports = [ inputs.anyrun.homeManagerModules.default ];

  home.packages = with pkgs; [
    libqalculate # Calculation library used by rofi
    # albert # Full-featured launcher
    anyrun # Modern full-featured launcher
  ];

  programs = {
    rofi = {
      enable = true;
      cycle = true;
      terminal = "${term.cmd} ${term.exec}";
      font = "FiraCode Nerd Font";
      theme = ./rounded-blue-dark.rasi;
      plugins = with pkgs; [ rofi-emoji-wayland ];
      pass = {
        enable = true;
        extraConfig = "";
        stores = [ "$XDG_DATA_HOME/password-store/" ];
      };
      extraConfig = {
        modes = "combi,drun,window,ssh,emoji";
        combi-modes = "window,drun,ssh,emoji";
        sorting-method = "fzf";
        show-icons = true;
      };
    };
    fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "${term.cmd} ${term.exec}";
          layer = "overlay";
        };
        colors = {
          background = "00000080";
          border = "00000000";
        };
      };
    };
    # anyrun = { # FIXME
    #   # DOC: https://github.com/Kirottu/anyrun
    #   enable = true; # TODO add flake and test
    #   package = pkgs.anyrun;
    #   config = {
    #     plugins = with inputs.anyrun.packages.${pkgs.system}; [
    #       applications
    #       dictionary
    #       kidex
    #       randr
    #       rink
    #       shell
    #       # stdin
    #       symbols
    #       translate
    #       websearch
    #     ];
    #     hideIcons = false;
    #     ignoreExclusiveZones = false;
    #     layer = "overlay";
    #     hidePluginInfo = false;
    #     closeOnClick = false;
    #     showResultsImmediately = false;
    #     maxEntries = 12;
    #   };
    # };
  };
}
