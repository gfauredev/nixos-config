{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pulsemixer # TUI to manage sound
  ];

  xdg.configFile = {
    pulsemixer = {
      target = "pulsemixer.cfg";
      source = ./pulsemixer.toml;
    };
  };
}
