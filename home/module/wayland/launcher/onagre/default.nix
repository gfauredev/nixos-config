{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      onagre # Desktop general purpose launcher
      # pop-launcher # Modular desktop launcher
      # papirus-icon-theme # Icon theme
    ];
}
