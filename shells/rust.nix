let
  rustOverlay = import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
  pkgs = import <nixpkgs> { overlays = [ rustOverlay ]; };
  rustVersion = "latest";
  rust = pkgs.rust-bin.stable.${rustVersion}.default.override
    # rust = pkgs.rust-bin.nightly.latest.default.override
    {
      extensions = [
        "rust-src" # for rust-analyzer
      ];
    };
  packages = with pkgs; [
    cargo
    carnix
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    vulkan-loader
    zlib
    brotli
    bzip2
    libpng
    libGL
    expat
    freetype
    freetype.dev
    fontconfig
    pkgconfig
    # rust-analyzer
  ];
in
pkgs.mkShell
{
  name = "iced-rust";
  buildInputs = [ rust ] ++ (packages);
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath packages;
  RUST_BACKTRACE = 1;
  shellHook = "exec zsh";
}
