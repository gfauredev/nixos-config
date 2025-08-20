{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lapce # The Lapce editor
  ];
}
