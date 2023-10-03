{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    pop-launcher # Modular desktop launcher
    onagre # Desktop general purpose launcher
    libqalculate # Calculation library used by rofi
  ];
}
