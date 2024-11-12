{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      albert # Full-featured launcher
    ];

  xdg.configFile = {
    config = {
      enable = false; # Albert edits its own config
      source = ./config;
    };
    websearch = {
      enable = false; # Albert edits its own config
      recursive = true;
      source = ./websearch;
    };
  };
}
