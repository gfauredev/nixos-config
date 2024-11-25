{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      # kicad # Elecronics design
      # fritzing # Elecronics design

      scilab-bin # Scientific computations
    ];
}

