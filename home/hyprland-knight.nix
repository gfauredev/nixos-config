{ inputs, lib, config, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enableNvidiaPatches = true;
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors
      # knight (ultrawide disktop) monitors
      monitor = [
        "eDP-1,2256x1504,0x0,1.4" # knight’s main monitor
        ",preferred,auto,1" # Externals monitor
        # ",preferred,auto,1,mirror,eDP-1" # Mirrored external monitors
      ];

      # See https://wiki.hyprland.org/Configuring/Workspace-Rules
      # knight (ultrawide disktop) workspaces
      workspace = [
        "name:web,monitor:eDP-1,default:true"
        "name:dpp,monitor:DP-1,default:true"
        "name:hdm,monitor:DP-2,default:true"
        "name:sup,monitor:DP-3,default:true"
        "name:ext,monitor:DP-4,default:true"
      ];
    };
  };
}
