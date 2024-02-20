{ pkgs, ... }: {
  home.packages = with pkgs; [
    pop-launcher # Modular desktop launcher
    onagre # Desktop general purpose launcher
    libqalculate # Calculation library used by rofi
    papirus-icon-theme # Icon theme
    wayland # wayland lib
    wayland-utils # wayland inffo
    wayland-protocols # wayland protocol extensions
  ];
}
