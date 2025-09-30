{ ... }: # Live NixOS ISO
{
  imports = [
    ./.
    ./module/wayland # Windows, Colors, Futile stuff # TEST if default OK
    ./module/web # Browsers
    ./module/document.nix # Document, Spreadsheet, Presentation, PDF
  ];
}
