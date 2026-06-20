{ pkgs-unstable, config, ... }:
{
  home.packages = [ pkgs-unstable.albert ]; # Full-featured launcher
  xdg.configFile = {
    "albert/config.link" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/albert/config";
    };
    "albert/websearch.link" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/albert/websearch";
    };
  };
}
