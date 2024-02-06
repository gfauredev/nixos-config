{ pkgs, ... }: {
  home.packages = with pkgs; [
    # blender # Most popular 3D, animation & video editor

    kicad # Elecronics design
    # fritzing # Elecronics design

    # cq-editor # GUI for Python library CadQuery
    # openscad # Parametric, programmatic (code only) 3D CAD

    freecad # Popular parametric 3D CAD
    # solvespace # Simple parametric 3D CAD
    # brlcad # Combinatorial solid modeling system

    super-slicer # Popular 3D printer slicer, fork of prusa-slicer
    # cura # Popular 3D printer slicer
  ];

  imports = [
    ./pkgs/blender.nix
  ];
}
