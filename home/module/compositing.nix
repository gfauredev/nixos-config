{ pkgs, ... }:
{
  home.packages = with pkgs; [
    natron # powerful non linear video editor
  ];
}
