{ inputs, lib, config, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enableNvidiaPatches = true;
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors
      # knight (ultrawide desktop) monitors
      monitor = [
        "DP-1,3440x1440,0x0,1.25" # knight’s main monitor
        ",preferred,auto,1" # Externals monitor
        # ",preferred,auto,1,mirror,eDP-1" # Mirrored external monitors
      ];

      # See https://wiki.hyprland.org/Configuring/Workspace-Rules
      # knight (ultrawide desktop) workspaces
      workspace = [
        "name:web,monitor:DP-1,default:true"
        "name:dpp,monitor:DP-2,default:true"
        "name:hdm,monitor:HDMI-A-1,default:true"
        "name:sup,monitor:DP-3,default:true"
        "name:ext,monitor:DP-4,default:true"
      ];
    };
  };
}
