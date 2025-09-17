{ pkgs, ... }:
{
  # TODO reorganise "science"
  home.packages = with pkgs; [
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
  ];
}
