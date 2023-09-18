# c-shell.nix
with import <nixpkgs> { };
let
  packages = [
    gcc
    clang
    cmake
    gnumake
    zig
    glib
    glibc
    gusb
    gobject-introspection
    # libpam-wrapper
    # pamtester

    # ccls # C/C++ language server
  ];
in
pkgs.mkShell
{
  name = "C";
  buildInputs = with pkgs; (packages);
  shellHook = "exec zsh";
}
