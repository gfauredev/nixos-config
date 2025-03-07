{ pkgs, ... }:
# let
#   py-slvs = pythonPkgs:
#     pythonPkgs.buildPythonPackage {
#       pname = "py-slvs";
#       version = "1.0.6";

#       src = pythonPkgs.fetchPypi {
#         pname = "py_slvs";
#         version = "1.0.6";
#         sha256 = "sha256-U6T/aXy0JTC1ptL5oBmch0ytSPmIkRA8XOi31NpArnI=";
#       };

#       nativeBuildInputs = with pkgs; [ swig ];
#       pyproject = true;

#       propagatedBuildInputs = with pythonPkgs; [
#         cmake
#         ninja
#         setuptools
#         scikit-build
#       ];

#       dontUseCmakeConfigure = true;

#       meta = with pkgs.lib; {
#         description = "Python binding of SOLVESPACE geometry constraint solver";
#         homepage = "https://github.com/realthunder/slvs_py";
#         license = licenses.gpl3;
#       };
#     };
#   blenderWithPySlvs = pkgs.blender.withPackages (p: [ (py-slvs p) ]);
# in
{
  home.packages = with pkgs; [
    # openscad # Parametric, programmatic 3D CAD
    # cq-editor # GUI for Python lib CadQuery

    dune3d # New parametric CAD
    # freecad # Popular parametric 3D CAD
    # solvespace # Simple parametric 3D CAD
    # brlcad # Combinatorial solid modeling system

    # blender # Most popular 3D, animation & video editor
    # blenderWithPySlvs # Patched popular 3D, animation & video editor
    # meshlab # 3D mesh processing tool

    bambu-studio # Bambu 3D printers’ slicer
    # cura # Popular 3D printer slicer
    # super-slicer # Popular 3D printer slicer, fork of prusa-slicer
  ];
}
