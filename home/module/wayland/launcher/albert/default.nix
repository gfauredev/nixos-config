{ pkgs-unstable, ... }:
{
  # TODO consider using mkOutOfStoreSymlink to make frequent changes easier
  # https://nixos-and-flakes.thiscute.world/best-practices/accelerating-dotfiles-debugging
  home.packages = [ pkgs-unstable.albert ]; # Full-featured launcher
  xdg.configFile = {
    "albert/config.static" = {
      source = ./config;
    };
    "albert/websearch.static" = {
      recursive = true;
      source = ./websearch;
    };
  };
}
