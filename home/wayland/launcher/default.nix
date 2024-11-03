{ pkgs, ... }: {
  imports = [ ./albert ./rofi ];

  home.packages = with pkgs;
    [
      libqalculate # Calculation library used by launchers
    ];
}
