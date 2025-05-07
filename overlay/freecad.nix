# FIXME openscad executable is not found
# FIXME python executable is not found
# See https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/fr/freecad/package.nix
(final: prev: { freecad = prev.freecad.override { }; })
