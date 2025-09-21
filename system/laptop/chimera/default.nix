{ ... }:
{
  imports = [
    ../.
    ./hardware.nix
  ];

  networking.hostName = "chimera";
  services.fprintd.enable = false;

  system.stateVersion = "25.05";
}
