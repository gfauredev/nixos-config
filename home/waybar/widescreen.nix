{ inputs, lib, config, pkgs, ... }: {
  programs = {
    waybar = {
      settings = {
        bottomBar = {
          window.max-length = 600;
          mpris.format = "{status_icon} {dynamic} {player_icon}";
        };
      };
    };
  };
}
