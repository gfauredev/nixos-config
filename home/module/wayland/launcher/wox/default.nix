{ pkgs, ... }: {
  home.packages = [ pkgs.wox ]; # Cross-platform launcher that simply works

  # xdg.configFile = {
  #   "wox/config.static" = { source = ./config; };
  #   "wox/websearch.static" = {
  #     recursive = true;
  #     source = ./websearch;
  #   };
  # };
}

