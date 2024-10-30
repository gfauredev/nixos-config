{ pkgs, term, ... }: {
  home.packages = with pkgs;
    [
      albert # Full-featured launcher
    ];

  xdg.configFile = {
    config = {
      enable = false;
      source = ./config;
    };
    websearch = {
      enable = false;
      recursive = true;
      source = ./websearch;
    };
  };
}
