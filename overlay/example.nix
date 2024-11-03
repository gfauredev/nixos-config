# Use `final` and `prev` to express the relationship between the new and the old
(final: prev: {
  steam = prev.steam.override {
    extraPkgs = pkgs:
      with pkgs; [
        keyutils
        libkrb5
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
      ];
    extraProfile = "export GDK_SCALE=2";
  };
})
