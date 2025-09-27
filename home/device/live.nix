{ ... }: # Live NixOS ISO
{
  imports = [
    ../default.nix
    ../module/wayland # Windows, Colors, Futile stuff # TEST if default OK
    ../module/web # Browsers
    ../module/document.nix # Document, Spreadsheet, Presentation, PDF
  ];
}
