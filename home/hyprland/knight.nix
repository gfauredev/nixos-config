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

  services.swayidle = {
    events = [
      { event = "before-sleep"; command = "${pkgs.playerctl}/bin/playerctl pause"; }
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f -c 000000"; } # FIXME Knight’s suspends crashes Hyprland
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
      # { timeout = 600; command = "${pkgs.systemd}/bin/systemctl suspend"; } # FIXME Knight’s suspends crashes Hyprland
    ];
  };
}
