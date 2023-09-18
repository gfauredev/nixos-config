# Libs & Programming languages
with import <nixpkgs> { };
let
  packages = [
    lua
  ];
in
pkgs.mkShell
{
  name = "lua";
  buildInputs = with pkgs; (packages);
  shellHook = "exec zsh";
}
