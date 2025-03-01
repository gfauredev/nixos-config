{
  description = "A Nix-flake-based C/C++ development environment";

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
          stdenv = pkgs.clangStdenv; # Use clang instead of gcc
        } {
          packages = with pkgs; [
            lldb # Debug adapter
            clang-tools # clang CLIs
            gnumake # Automation tool
            cmake # Automation tool
            cmake-language-server # LSP
            valgrind # Debugging and profiling
            cppcheck # Static analysis
            gtest # Testing framework
            lcov # Code coverage
            doxygen # Documentation generator
            SDL2 # Graphics library
            SDL2_ttf # Graphics library for text
          ];
        };
      });
    };
}
