{ pkgs, ... }: # Photo & Image Edition
{
  home.packages = with pkgs; [
    gimp3-with-plugins # Raster image editor
    lorien # Infinite canvas drawing/note-taking app
    friction-graphics # Motion graphics vector raster
    inkscape # Vector image editor
    darktable # RAW pictures editor
    krita # Raster image painting/drawing editor
  ];
}
