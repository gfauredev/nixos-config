{ inputs, lib, config, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors
      # ninja (Framework Laptop 13) monitors
      monitor = [
        "eDP-1,2256x1504,0x0,1.4" # ninja’s internal monitor
        ",preferred,auto,1" # Externals monitor
        # ",preferred,auto,1,mirror,eDP-1" # Mirrored external monitors
      ];

      # See https://wiki.hyprland.org/Configuring/Workspace-Rules
      # ninja (Framework Laptop 13) workspaces
      workspace = [
        "name:web,monitor:eDP-1,default:true"
        "name:dpp,monitor:DP-1,default:true"
        "name:hdm,monitor:DP-2,default:true"
        "name:sup,monitor:DP-3,default:true"
        "name:ext,monitor:DP-4,default:true"
      ];
    };
  };

  services.swayidle = {
    events = [
      { event = "before-sleep"; command = "${pkgs.playerctl}/bin/playerctl pause"; }
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f -c 000000"; }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
      {
        timeout = 330;
        command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      }
      { timeout = 600; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };
}
