{ ... }:
{
  networking.hostName = "cerberus";
  imports = [ ./module/server.nix ];
  system.stateVersion = "25.05";
}
