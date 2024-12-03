{ pkgs, ... }: {
  home.packages = with pkgs; [
    # kicad # Elecronics design
    # fritzing # Elecronics design
    xyce # Analog circuit simulator
    # gnucap-full # Circuit analysis
    # ngspice # Electronic circuit simulator

    scilab-bin # Scientific computations
  ];
}

