{ ... }:
{
  imports = [ ./default.nix ];

  wayland.windowManager.hyprland = {
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors
      # Griffin (Framework Laptop 13) monitors
      monitor = [
        {
          output = "eDP-1"; # Griffin’s internal monitor, scale 1.333
          mode = "2256x1504";
          position = "0x0";
          scale = 1.333;
        }
        # Center above internal display: (3440-(2256/1.333))/2≃873,78…
        {
          output = "desc:Huawei Technologies Co. Inc. ZQE-CAA 0xC080F622";
          mode = "3440x1440@144";
          position = "-874x-1440";
          scale = 1;
        }
        {
          output = "desc:IGM Communi L238DPH-NS-BU 0x01010101";
          mode = "1920x1080@60";
          position = "-1920x-540";
          scale = 1;
        }
        {
          output = "desc:NEC Corporation EA221WM 0x01010101";
          mode = "1680x1050@60";
          position = "auto-up";
          scale = 1;
        }
        {
          output = ""; # Default to above for other monitors
          mode = "preferred";
          position = "auto-up";
          scale = 1;
        }
      ];
      # Griffin (Framework Laptop 13) workspaces
      workspace_rule = [
        # Note: Every port is DP through USB-C on Framework Laptop 13
        # TODO Declaratively from ./hyprland/workspaces.nix
        {
          workspace = "name:hdm"; # Bottom Left: TV, Projector…
          monitor = "DP-3";
          default = true;
        }
        {
          workspace = "name:dpp"; # Top Left: Desk monitor, Hub…
          monitor = "DP-4";
          default = true;
        }
        {
          workspace = "name:int"; # FW13’s internal monitor
          monitor = "eDP-1";
          default = true;
        }
      ];
      env = [
        {
          _args = [
            "GDK_SCALE" # Set scaling on Xwayland
            "1.25"
          ];
        }
      ];
    };
  };
}
