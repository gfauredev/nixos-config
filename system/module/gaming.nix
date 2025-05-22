{ lib, pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [
      lutris # Gaming platform
    ];

  services.sunshine = { # Moonlight compatible server
    enable = false; # TEST remote gaming
    # See: https://docs.lizardbyte.dev/latest
    applications = { # TODO configure (example below)
      env = { PATH = "$(PATH):$(HOME)/.local/bin"; };
      apps = [{
        name = "App";
        prep-cmd = [{
          do = "${pkgs.app}/bin/ap";
          undo = "${pkgs.app}/bin/ap";
        }];
        exclude-global-prep-cmd = "false";
        auto-detach = "true";
      }];
    };
  };

  programs = {
    steam = {
      enable = true;
      # gamescopeSession.enable = true;
      remotePlay.openFirewall = lib.mkDefault false; # Open ports
      dedicatedServer.openFirewall = lib.mkDefault false; # Open ports
    };
    # gamemode.enable = true;
    # gamescope.enable = true;
  };
}
