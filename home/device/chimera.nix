{ ... }: # Main user gf @ Secondary laptop Chimera
{
  imports = [
    ../default.nix
    ../module/wayland/chimera.nix
  ];
}
