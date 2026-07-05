{ pkgs, ... }: # Photo & Image Edition
{
  home.packages = with pkgs; [
    gimp3-with-plugins # Raster image editor
    # darktable # RAW pictures editor
    # inkscape # Vector image editor
    # krita # Raster image painting/drawing editor
    # graphite # New vector and raster image editor
  ];
}
