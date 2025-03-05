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

    home.sessionVariables = {
      HYPRCURSOR_THEME = "Bibata-Hypr-Ice"; # Modern cursor theme
      HYPRCURSOR_SIZE = "22";
    };

    programs = {
      hyprlock = {
        enable = true;
        settings = {
          background = [{
            path = "screenshot";
            blur_passes = 2;
            blur_size = 3;
          }];
          input-field = [{
            size = "250, 50";
            outline_thickness = 2;
            dots_size = 0.35;
            dots_spacing = 0.15;
            dots_center = true;
            dots_rounding = -1;
            fade_on_empty = true;
            fade_timeout = 2000;
            placeholder_text = "Passphrase / Fingerprint";
            hide_input = false;
            fail_text = "$FAIL ($ATTEMPTS)";
            fail_transition = 300;
            capslock_color = -1;
            numlock_color = -1;
            bothlock_color = -1;
            position = "0, 0";
            halign = "center";
            valign = "center";
            outer_color = "rgb(000000)"; # TODO Stylix
            inner_color = "rgb(000000)"; # TODO Stylix
            font_color = "rgb(ffddcc)"; # TODO Stylix
            check_color = "rgb(b6a482)"; # TODO Stylix
            fail_color = "rgb(fe4321)"; # TODO Stylix
          }];
        };
      };
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
      "PASSWORD_STORE_DIR,${config.home.sessionVariables.PASSWORD_STORE_DIR}"
    ];
  };
}
