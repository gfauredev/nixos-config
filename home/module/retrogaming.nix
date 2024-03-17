{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      (retroarch.override {
        cores = with libretro;
          [
            fbneo # Arcade machines
            # mame # Arcade machines
            # mame2003-plus # Arcade machines
            # mame2010 # Arcade machines
            # beetle-gba # Gamebox Advance
            # snes9x # Super Nintendo
            # genesis-plus-gx # Sega Genesis
          ];
      })
    ];
}
