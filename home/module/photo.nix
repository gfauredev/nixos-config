{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    # TODO use specific options when possible
    darktable # RAW pictures editing
    gimp # image editor
    inkscape # vector image editor
    # krita # image editor
  ];
}
