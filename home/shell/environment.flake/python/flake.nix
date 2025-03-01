{
  description = "Python env";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              uv # Python project and packages management
              ruff # Lint, Format, LSP
              mypy # Type check, launch as server with `dmypy start`
              # TODO add type checkers
            ];
          };
        };
      });
}
