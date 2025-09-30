{ pkgs, ... }:
{
  home.packages = [ pkgs.wox ]; # Cross-platform launcher that simply works

  xdg.configFile = {
    # "wox/settings/wox.static.json" = { source = ./settings.json; };
    # "wox/settings/wox.data.static.json" = { source = ./settings.data.json; };
    # "wox/settings.static" = {
    #   recursive = true;
    #   source = ./settings;
    # };
    # "wox/plugins.static" = {
    #   recursive = true;
    #   source = ./plugins;
    # };
    # "wox/themes.static" = {
    #   recursive = true;
    #   source = ./themes;
    # };
  };
}
