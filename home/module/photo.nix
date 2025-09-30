{ pkgs, ... }:
{
  imports = [
    ./qimgv # Fully-featured image and video viewer
  ];
  home.packages = with pkgs; [
    viu # CLI image viewer
    qimgv # Another image viewer
    imagemagick # CLI image edition
    # darktable # RAW pictures editor TODO reenable
    gimp-with-plugins # Raster image editor
    # inkscape # Vector image editor TODO reenable
    # graphite # New vector and raster image editor
    # krita # Raster image painting/drawing editor
    cheese # Webcam capture
  ];
}
