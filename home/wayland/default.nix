{ pkgs, config, lib, ... }: {
  imports = [ ./hyprland ./launcher ./eww ./waybar ./remap ];

  options.wayland = {
    lock = lib.mkOption {
      # type = lib.types.str;
      default = "${pkgs.hyprlock}/bin/hyprlock";
      description = "Screen/session lock command";
    };
    lock-session = lib.mkOption {
      default = "${pkgs.systemd}/bin/loginctl lock-session";
      description = "Standard session lock command";
    };
    suspend = lib.mkOption {
      default = "${pkgs.systemd}/bin/systemctl suspend";
      description = "Standard system suspend command";
    };
  };

  config = {
    home.packages = with pkgs; [
      wl-clipboard # Copy from CLI
      wl-mirror # Mirror wayland output
      grim # Take screenshots
      slurp # Select a screen zone with mouse
      wev # Evaluate inputs sent to wayland to debug
      libnotify # Notifications management
      hyprpicker # Better color picker
      wayland-utils # wayland info
    ];

    xdg.dataFile."icons/Bibata-Hypr-Ice".source =
      ./Bibata-Modern-Ice.hyprcursor;

    # home.sessionVariables = {
    #   HYPRCURSOR_THEME = "Bibata-Hypr-Ice"; # Modern cursor theme
    #   HYPRCURSOR_SIZE = "22";
    # };

    programs = {
      hyprlock.enable = true;
      # hyprlock.settings = { TODO
      #     background = [{
      #       path = "screenshot";
      #       blur_passes = 2;
      #       blur_size = 3;
      #     }];
      #   };
      rofi.package = pkgs.rofi-wayland; # Set this for wayland
    };

    services.hypridle.settings.listener = [
      {
        timeout = 300; # Lock session, (blur and dim screen)
        on-timeout = "${config.wayland.lock}";
      }
      {
        timeout = 600; # Put the computer to sleep
        # NOTE hacky way to prevent sleep if eGPU connected,
        # because currently sleeping with eGPU crashes the system
        on-timeout =
          "[ -e $XDG_CONFIG_HOME/hypr/egpu ] || ${config.wayland.suspend}";
      }
    ];

    # TODO cleaner with Nix modules, options
    wayland.windowManager.hyprland.settings.env = [
      "NIXOS_OZONE_WL,1" # Force Wayland support for some apps (Chromium)
      "TERM,${config.term.cmd}" # Default terminal
      "TERM_EXEC,${config.term.exec}" # Default terminal run args
      # FIX Set these variables again, home.sessionVariables don’t seem effective
      "XDG_CONFIG_HOME,${config.home.sessionVariables.XDG_CONFIG_HOME}"
      "SHELL,${config.home.sessionVariables.SHELL}" # Set Nushell as interactive shell
      "EDITOR,${config.home.sessionVariables.EDITOR}" # Force default editor
      "PAGER,${config.home.sessionVariables.PAGER}" # Force default pager
      "PASSWORD_STORE_DIR,${config.home.sessionVariables.PASSWORD_STORE_DIR}"
    ];
  };
}
