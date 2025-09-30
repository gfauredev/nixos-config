{ ... }: # Secondary laptop Chimera
{
  imports = [
    ./.
    ./module/wayland/chimera.nix
  ];
}
