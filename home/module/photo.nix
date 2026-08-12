{ pkgs, ... }: # Photo & Image Edition
{
  home.packages = with pkgs; [
    gimp3-with-plugins # Raster image editor
    lorien # TEST
    friction-graphics # TEST
    # inkscape # Vector image editor TEST
    # darktable # RAW pictures editor
    # krita # Raster image painting/drawing editor
  ];
}
