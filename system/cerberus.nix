{ ... }:
{
  networking.hostName = "cerberus";
  imports = [ ./module/server.nix ];
}
