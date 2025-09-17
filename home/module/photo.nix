{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # darktable # RAW pictures editor TODO reenable
    gimp-with-plugins # Raster image editor
    # inkscape # Vector image editor TODO reenable
    # graphite # New vector and raster image editor
    # krita # Raster image painting/drawing editor
    cheese # Webcam capture
  ];
}
