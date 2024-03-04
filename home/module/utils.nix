# Useful programs
{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Theme & Style
    # libsForQt5.qt5ct # TEST if relevant
    libsForQt5.qtstyleplugin-kvantum # TEST if relevant
    # libsForQt5.qt5.qtwayland # TEST if relevant
    # qt6Packages.qt6ct # TEST if relevant
    qt6Packages.qtstyleplugin-kvantum # TEST if relevant
    # qt6.qtwayland # TEST if relevant
    # libsForQt5.systemsettings # TEST if relevant
    # adwaita-qt # TEST if relevant
    # glib # GTK Tools
    # gsettitngs-qt # GTK Settings
    asciiquarium-transparent # Best screensaver ever

    # Cleaning & Desktop monitoring
    # bleachbit # Good old cleaner
    # czkawka # Modern cleaner
    # stacer # Modern cleaner & monitoring

    # Misc
    testdisk # file recuperation
    restic # Efficient backup
    ventoy-full # create bootable keys
    udiskie # auto mount USB
    # dcfldd # more powerful dd
  ];
}
