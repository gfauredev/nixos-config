{ pkgs, ... }: {
  home.packages = with pkgs; [
    blender # most popular 3D, animation & video editor
    # natron # powerful non linear video editor
  ];
}
