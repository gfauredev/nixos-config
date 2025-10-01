{ ... }: # Doesn’t works for both pkgs and pkgs-unstable
{
  nixpkgs.overlays = [
    # `self` and `super` to express the inheritance relationship
    # (self: super: { _7zz = super._7zz.override { useUasm = true; }; })
    # `final` and `prev` to express relationship between new and the old
    # (final: prev: { freecad = prev.freecad.override { }; })
  ];
}
