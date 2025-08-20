{ ... }:
{
  # Overlays defined in individual files
  nixpkgs.overlays = [
    # (import ./freecad.nix)
    # (import ./7zz.nix)
  ];
}
