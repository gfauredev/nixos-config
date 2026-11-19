{
  lib,
  pkgs-unstable,
  ...
}:
{
  services.sunshine.enable = false; # Moonlight compatible server, see https://docs.lizardbyte.dev/latest TODO
  programs = {
    steam.enable = true;
    gamemode.enable = true;
    gamescope.enable = false;
    steam = {
      package = pkgs-unstable.steam;
      gamescopeSession.enable = false;
      remotePlay.openFirewall = lib.mkDefault false; # Open ports
      dedicatedServer.openFirewall = lib.mkDefault false; # Open ports
    };
  };
}
