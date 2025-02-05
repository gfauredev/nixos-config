{
  description = "C/C++ development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems
        (system: f { pkgs = import nixpkgs { inherit system; }; });
    in {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell.override {
          # stdenv = pkgs.clangStdenv; # Change compiler
        } {
          packages = with pkgs; [
            gdb
            gnumake
            cmake
            codespell
            cppcheck
            conan
            clang-tools
            doxygen
            gtest
            lcov
            vcpkg
            vcpkg-tool
            valgrind
            # python313Packages.lizard
          ];
        };
      });
    };
}
