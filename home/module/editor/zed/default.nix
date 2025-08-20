{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zed-editor # Modern text editor
  ];
}
