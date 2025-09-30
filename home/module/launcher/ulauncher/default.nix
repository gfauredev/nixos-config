{ pkgs, ... }:
{
  # See https://docs.ulauncher.io
  home.packages = with pkgs; [
    ulauncher # General launcher for Linux, Python, extensible
  ];
}
