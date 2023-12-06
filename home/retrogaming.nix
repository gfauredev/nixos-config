{ pkgs, ... }: {
  home.packages = with pkgs; [
    (retroarch.override {
      cores = with libretro; [
        beetle-gba # Gamebox Advance
        snes9x # Super Nintendo
        genesis-plus-gx # Sega Genesis
        mame # Arcade machines
      ];
    })
  ];
}
