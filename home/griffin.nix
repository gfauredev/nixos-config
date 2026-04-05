{ ... }: # Main laptop Griffin
{
  imports = [
    ./. # Default home
    ./module/wayland/griffin.nix # Windows, Colors, Futile stuff
    ./module/web # Browsers
    ./module/organization.nix # Email, Calendar, Task, Contact, Note
    ./module/document.nix # Document, Spreadsheet, Presentation, PDF
    ./module/audio.nix # Audio Production & Creation
    ./module/qimgv # Fully-featured image and video viewer
    ./module/photo.nix # Photo & Image Edition
    ./module/video.nix # Video Edition
  ];
  # home.packages = with pkgs; [ geteduroam-cli ];
}
