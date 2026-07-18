{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./hyprland
    ./waybar
  ];

  options.wayland = {
    lock = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.hyprlock}/bin/hyprlock";
      description = "Screen/session lock command";
    };
    lock-session = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.systemd}/bin/loginctl lock-session";
      description = "Standard session lock command";
    };
  };

  config = {
    home.packages = with pkgs; [
      wl-clipboard # Copy from CLI
      wl-mirror # Mirror wayland output
      grim # Take screenshots
      slurp # Select a screen zone with mouse
      libnotify # Notifications management
      hyprpicker # Better color picker
      wayland-utils # wayland info
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ config.stylix.fonts.serif.name ];
        sansSerif = [ config.stylix.fonts.sansSerif.name ];
        monospace = [ config.stylix.fonts.monospace.name ];
        emoji = [ config.stylix.fonts.emoji.name ];
      };
    };

    programs = {
      swayimg.enable = true;
      hyprlock.enable = true;
    };

    services.hypridle.settings.listener = [
      {
        timeout = 90; # Lock session (blur and dim screen) after 1min 30
        on-timeout = config.wayland.lock;
      }
      {
        timeout = 180; # Put the computer to sleep after 3 minutes
        on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };
}
