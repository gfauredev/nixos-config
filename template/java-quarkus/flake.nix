{
  description = "Quarkus Java Framework";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems
        (system: f { pkgs = import nixpkgs { inherit system; }; });
    in {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell { # .override {
          # Override stdenv in order to change compiler:
          # stdenv = pkgs.clangStdenv;
          # } {
          packages = with pkgs; [
            jdk
            quarkus
            maven
            ant
            jdt-language-server
            doxygen
            # gnumake
          ];
          shellHook = "exec zsh";
        };
      });
    };
}
