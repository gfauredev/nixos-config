{ ... }:
{
  imports = [
    ../.
    ./hardware.nix
  ];

  networking.hostName = "chimera";
  networking.hostId = "acabacab";

  services.fprintd.enable = false;

  system.stateVersion = "25.05";
}
