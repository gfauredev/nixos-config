{ lib, pkgs, ... }:
{
  services.sunshine.enable = false; # Moonlight compatible server, see https://docs.lizardbyte.dev/latest TODO
  services.sunshine.applications = {
    env = {
      PATH = "$(PATH):$(HOME)/.local/bin";
    };
    apps = [
      {
        name = "App";
        prep-cmd = [
          {
            do = "${pkgs.app}/bin/ap";
            undo = "${pkgs.app}/bin/ap";
          }
        ];
        exclude-global-prep-cmd = "false";
        auto-detach = "true";
      }
    ];
  };

  programs = {
    steam.enable = true;
    gamemode.enable = true;
    gamescope.enable = false;
    steam = {
      gamescopeSession.enable = false;
      remotePlay.openFirewall = lib.mkDefault false; # Open ports
      dedicatedServer.openFirewall = lib.mkDefault false; # Open ports
    };
  };
}
