{ pkgs, ... }: {
  home.packages = with pkgs; [
    librepcb # Modern EDA software
    kicad # Elecronics (EDA) software
    # fritzing # Elecronics (EDA) software
    # xschem # Schematic editor TODO imperative install
    # xyce # -parallel # Analog circuit simulator TODO imperative install
    # gnucap-full # Circuit analysis
    # ngspice # Electronic circuit simulator
    # scilab-bin # Scientific computations TODO install imperatively
  ];
}

