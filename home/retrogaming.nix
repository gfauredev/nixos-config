{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    (retroarch.override {
      cores = with libretro; [
        snes9x
      ];
    })
  ];
}
