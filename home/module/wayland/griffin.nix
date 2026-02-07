{ ... }:
{
  imports = [ ./default.nix ];

  wayland.windowManager.hyprland = {
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors
      # Griffin (Framework Laptop 13) monitors
      monitor = [
        "eDP-1, 2256x1504, 0x0, 1.333" # Griffin’s internal monitor, scale 1.333
        # "desc:Huawei Technologies Co. Inc. ZQE-CAA 0xC080F622, 3440x1440@144, auto-up, 1"
        # Center above internal display: (3440-(2256/1.333))/2≃873,78…
        "desc:Huawei Technologies Co. Inc. ZQE-CAA 0xC080F622, 3440x1440@144, -874x-1440, 1"
        # "desc:Huawei Technologies Co. Inc. ZQE-CAA 0xC080F622, 3440x1440@144, -767x-1350, 1.0666"
        "desc:IGM Communi L238DPH-NS-BU 0x01010101, 1920x1080@60, -1920x-540, 1"
        "desc:NEC Corporation EA221WM 0x01010101, 1680x1050@60, auto-up, 1"
        # "desc:NEC Corporation EA221WM 0x01010101, 1680x1050@60, -323x-1050, 1"
        ", preferred, auto-up, 1" # Default to above for other monitors
        # ", 1920x1080, -114x-1080, 1"
        # ", 1920x1200, -114x-1200, 1"
      ];
      # Griffin (Framework Laptop 13) workspaces
      workspace = [
        # Note: Every port is DP through USB-C on Framework Laptop 13
        # TODO Declaratively from ./hyprland/workspaces.nix
        # "name:, monitor:DP-1, default:true" # Top Right port
        # "name:, monitor:DP-2, default:true" # Bottom Right port
        "name:hdm, monitor:DP-3, default:true" # Bottom Left: TV, Projector…
        "name:dpp, monitor:DP-4, default:true" # Top Left: Desk monitor, Hub…
        "name:int, monitor:eDP-1, default:true" # FW13’s internal monitor
      ];
      env = [ "GDK_SCALE,1.25" ]; # Set scaling on Xwayland
    };
  };
}
