{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      albert # Full-featured launcher
    ];

  # NOTE disabled because albert modfies its own config
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
