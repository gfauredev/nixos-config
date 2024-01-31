{ pkgs, ... }: {
  home.packages = with pkgs; [
    # blender # Most popular 3D, animation & video editor

    fritzing # Elecronics design
    # kicad # Elecronics design

    # openscad # Parametric, programmatic (code only) 3D CAD
    # Use Python library CadQuery instead

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
