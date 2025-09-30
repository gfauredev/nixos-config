{ ... }: # Main laptop Griffin
{
  imports = [
    ./. # Default home
    ./module/wayland/griffin.nix # Windows, Colors, Futile stuff
    ./module/web # Browsers
    ./module/organization.nix # PIM, Note
    ./module/document.nix # Document, Spreadsheet, Presentation, PDF
    ./module/audio.nix # Audio
    ./module/photo.nix # Images
    ./module/misc.nix # Message, Transact, Exchange TODO organize better
  ];
}
