{ pkgs, ... }: {
  imports = [ ./rofi ./albert ];

  home.packages = with pkgs;
    [
      libqalculate # Calculation library used by launchers
    ];
}
