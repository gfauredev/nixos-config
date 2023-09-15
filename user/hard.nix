{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    # TODO use specific options when possible
    openscad
    kicad
    # fritzing
    # brlcad
    # freecad
    # ideamaker
  ];
}
