{ ... }: # Main laptop Griffin
{
  imports = [
    ./.
    ./module/wayland/griffin.nix # Windows, Colors, Futile stuff
    ./module/web # Browsers
    ./module/organization.nix # PIM, Note, Message, Transact, Exchange TODO find a better name/organization
    ./module/document.nix # Document, Spreadsheet, Presentation, PDF
    ./module/audio.nix
    ./module/photo.nix
    ./module/qimgv # Fully-featured image and video viewer
  ];
}
