{ pkgs-unstable, ... }:
{
  home.packages = [ pkgs-unstable.albert ]; # Full-featured launcher
  xdg.configFile = {
    "albert/config.static" = {
      source = ./config;
      # source = config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/albert/config";
    };
    "albert/websearch.static" = {
      recursive = true;
      source = ./websearch;
      # source = config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/albert/websearch";
    };
  };
}
