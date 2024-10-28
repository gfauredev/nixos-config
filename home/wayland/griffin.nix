{ pkgs, ... }: {
  imports = [ ./default.nix ];

  wayland.windowManager.hyprland = {
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors
      # Griffin (Framework Laptop 13) monitors
      monitor = [
        "eDP-1, 2256x1504, 0x0, 1.333" # Griffin’s internal monitor
        "desc:Huawei Technologies Co. Inc. ZQE-CAA 0xC080F622, 3440x1440@144, -874x-1440, 1"
        # "desc:Huawei Technologies Co. Inc. ZQE-CAA 0xC080F622, 3440x1440@144, -767x-1350, 1.0666"
        "desc:IGM Communi L238DPH-NS-BU 0x01010101, 1920x1080@60, -1920x-540, 1"
        ", 1920x1080, -114x-1080, 1"
        ", 1920x1200, -114x-1200, 1"
        ", preferred, auto, 1" # Other monitors
      ];
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules
      # Griffin (Framework Laptop 13) workspaces
      workspace = [
        # Every port is considered DP on Framework Laptops
        "name:sup, monitor:eDP-1, default:true"
        "name:dpp, monitor:DP-1, default:true"
        "name:hdm, monitor:DP-2, default:true"
        "name:etc, monitor:DP-7, default:true"
        # "name:ext, monitor:DP-3, default:true"
      ];
      env = [
        # Launch on eGPU if available, integrated one instead
        # WARNING depends on stateful configurations TODO find a cleaner (Nix) way :
        ## ln -sf /dev/dri/by-path/pci-0000:00:02.0-card .config/hypr/igpu
        ## ln -sf /dev/dri/by-path/pci-0000:7f:00.0-card .config/hypr/egpu
        "WLR_DRM_DEVICES,$HOME/.config/hypr/egpu:$HOME/.config/hypr/igpu"
      ];
    };
  };

  services.hypridle.settings.listener = [
    {
      timeout = 300; # Lock session, (blur and dim screen)
      on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
      # on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
    }
    # {
    #   timeout = 300; # Dim screen
    #   on-timeout = "brightnessctl set 1%";
    # }
    {
      timeout = 600; # Put the computer to sleep
      # on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
      # WARNING hacky way to prevent sleep if eGPU connected TODO find a cleaner way :
      on-timeout =
        "[ -e $XDG_CONFIG_HOME/hypr/egpu ] || ${pkgs.systemd}/bin/systemctl suspend";
      # on-resume = "hyprctl dispatch dpms on";
    }
  ];

  # services.swayidle = {
  #   events = [
  #     {
  #       event = "before-sleep"; # Pause music before sleep
  #       command = "${pkgs.playerctl}/bin/playerctl pause";
  #     }
  #     {
  #       event = "before-sleep"; # Lock screen
  #       command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
  #     }
  #   ];
  #   timeouts = [
  #     {
  #       timeout = 300; # Just turn off the screen
  #       command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
  #       resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
  #     }
  #     {
  #       timeout = 330; # Lock screen
  #       command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
  #     }
  #     {
  #       timeout = 600; # Put the computer to sleep
  #       command = "${pkgs.systemd}/bin/systemctl suspend";
  #     }
  #   ];
  # };
}
