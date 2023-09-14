{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    # TODO use specific options when possible
    gimp # image editor
    # krita # image editor
    inkscape # vector image editor
    darktable # RAW pictures editing
  ];
}
