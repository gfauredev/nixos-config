{ ... }:
{
  # Overlays defined in individual files
  nixpkgs.overlays = [
    (import ./bambu.nix)
    # (import ./freecad.nix)
    # (import ./7zz.nix)
  ];
}
