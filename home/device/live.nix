{ lib, ... }: # Live NixOS ISO
{
  imports = [
    ../default.nix
    ../module/wayland # Windows, Colors, Futile stuff # TEST if default OK
    ../module/web # Browsers
    ../module/document.nix # Document, Spreadsheet, Presentation, PDF
  ];

  options = {
    user = lib.mkOption {
      default = { };
      description = "This home’s user";
    };
    media.favorite = lib.mkOption {
      default = "spotify"; # Preferred media app
      description = "favorite media app";
    };
  };
}
