{ pkgs, ... }: # Could be sorted better
{
  home.packages = with pkgs; [
    # f3d # Minimalist 3D viewer
    # Electronics
    horizon-eda # Modern EDA to develop printed circuit boards
    # quartus-prime-lite # Intel FPGA design software
    # kicad # Electronics (EDA) software BUG building
    # librepcb # Modern EDA software
    # fritzing # Elecronics (EDA) software
    # xschem # Schematic editor TODO imperative install
    # xyce # -parallel # Analog circuit simulator TODO imperative install
    # gnucap-full # Circuit analysis
    # ngspice # Electronic circuit simulator
    # scilab-bin # Scientific computations TODO install imperatively
    # stm32flash # Open source flash program for the STM32 ARM processors
    # stm32cubemx # Graphical tool for configuring STM32 microcontrollers
    # 3D CAD
    freecad-wayland # Popular parametric 3D CAD
    dune3d # New simple parametric CAD
    # solvespace # Simple parametric 3D CAD
    # brlcad # Combinatorial solid modeling system
    # 3D Artistic
    # blender # Most popular 3D, animation & video editor
    # blenderWithPySlvs # Patched popular 3D, animation & video editor
    # meshlab # 3D mesh processing tool
    # Slicing
    bambu-studio # Bambu 3D printers’ slicer
    # cura # Popular 3D printer slicer
    # super-slicer # Popular 3D printer slicer, fork of prusa-slicer
  ];
}
