{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      albert # Full-featured launcher
    ];

  xdg.configFile = {
    "albert/config.static" = { source = ./config; };
    "albert/websearch.static" = {
      recursive = true;
      source = ./websearch;
    };
  };
}
