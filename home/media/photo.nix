{ pkgs, ... }: {
  home.packages = with pkgs; [
    darktable # RAW pictures editing
    gimp # image editor
    inkscape # vector image editor
    # krita # image editor
    gnome.cheese # Webcam capture
  ];
}
