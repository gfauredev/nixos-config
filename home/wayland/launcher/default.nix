{ pkgs, term, inputs, ... }: {
  imports = [ inputs.anyrun.homeManagerModules.default ];

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
      # plugins = with pkgs; [ rofi-calc rofi-emoji ];
      pass = {
        enable = true;
        extraConfig = "";
        stores = [ "$HOME/.password-store/" ];
      };
      extraConfig = {
        modes = "combi,drun,window,ssh"; # ,calc,emoji";
        combi-modes = "window,drun,ssh"; # ,emoji";
        sorting-method = "fzf";
        show-icons = true;
      };
    };
    fuzzel = {
      enable = true; # TODO test
      # settings = {};
    };
    anyrun = { # FIXME
      # DOC: https://github.com/Kirottu/anyrun
      enable = true; # TODO add flake and test
      package = pkgs.anyrun;
      config = {
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          applications
          dictionary
          kidex
          randr
          rink
          shell
          # stdin
          symbols
          translate
          websearch
        ];
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = false;
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = 12;
      };
    };
  };
}
