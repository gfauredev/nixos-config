{
  description = "OpenSCAD env";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              openscad # Main tool
              openscad-lsp # LSP
              # freecad # GUI
              # sca2d # OpenSCAD static analyser
              # turbocase # Auto generate a case from a KiCAD PCB
            ];
          };
        };
      });
}
