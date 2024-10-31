{ pkgs, ... }: {
  imports = [ ./albert ./rofi ./anyrun ];

  home.packages = with pkgs;
    [
      libqalculate # Calculation library used by launchers
    ];
}
