{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      albert # Full-featured launcher
    ];

  xdg.configFile = {
    "albert/config" = {
      enable = false; # Albert edits its own config
      source = ./config;
    };
    "albert/websearch" = {
      enable = false; # Albert edits its own config
      recursive = true;
      source = ./websearch;
    };
  };
}
