{ pkgs, ... }: {
  imports = [ ./default.nix ./waybar/widescreen.nix ];

  # home.sessionVariables = {
  #   GDK_SCALE = "1.25"; # Scaling on Xwayland
  #   WLR_NO_HARDWARE_CURSORS = "1"; # FIX for invisible cursor on nvidia
  #   SDL_VIDEODRIVER = "wayland"; # Force apps to use Wayland SDL
  # };

  wayland.windowManager.hyprland = {
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors
      # Typhon (ultrawide desktop) monitors
      monitor = [
        "DP-1, 3440x1440, 0x0, 1.25" # Typhon’s main monitor
        ", preferred, auto, 1" # Externals monitor
      ];
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules
      # Typhon (ultrawide desktop) workspaces
      workspace = [
        "name:sup, monitor:DP-1, default:true"
        "name:dpp, monitor:DP-2, default:true"
        "name:hdm, monitor:HDMI-A-1, default:true"
        # "name:etc, monitor:DP-3, default:true"
        # "name:ext, monitor:DP-4, default:true"
      ];

      env = [ # TEST pertinence of each
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];
    };
  };

  services.swayidle = {
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.playerctl}/bin/playerctl pause";
      }
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      } # FIXME Typhon’s suspends crashes Hyprland
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
      # { timeout = 600; command = "${pkgs.systemd}/bin/systemctl suspend"; } # FIXME Typhon’s suspends crashes Hyprland
    ];
  };
}
