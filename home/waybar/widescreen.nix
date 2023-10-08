{ inputs, lib, config, pkgs, ... }: {
  programs = {
    waybar = {
      settings = {
        bottomBar = {
          window.max-length = 600;
          mpris.format = "{player_icon} {status_icon} {dynamic}";
        };
      };
    };
  };
}
