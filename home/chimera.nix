{ ... }: # Secondary laptop Chimera
{
  imports = [
    ./. # Default home config
    ./module/wayland/chimera.nix # Windows, Colors, Futile stuff
    ./module/web # Browsers
    ./module/document.nix # Document, Spreadsheet, Presentation, PDF
  ];
}
