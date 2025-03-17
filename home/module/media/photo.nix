{ pkgs, stablepkgs, ... }: {
  home.packages = with pkgs; [
    darktable # RAW pictures editor
    stablepkgs.gimp-with-plugins # Raster image editor
    inkscape # Vector image editor
    # graphite # New vector and raster image editor
    # krita # Raster image painting/drawing editor
    cheese # Webcam capture
  ];
}
