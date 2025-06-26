{ pkgs, config, lib, ... }: {
  imports = [ ./hyprland ./launcher ./waybar ./remap ];

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

    xdg.dataFile."icons/Bibata-Hypr-Ice".source =
      ./Bibata-Modern-Ice.hyprcursor;

    programs = {
      hyprlock.enable = true;
      rofi.package = pkgs.rofi-wayland; # Set this for wayland
    };

    services.hypridle.settings.listener = [
      {
        timeout = 300; # Lock session, (blur and dim screen)
        on-timeout = config.wayland.lock;
      }
      {
        timeout = 600; # Put the computer to sleep
        on-timeout = config.wayland.suspend;
        # NOTE hacky way to prevent sleep if eGPU connected,
        # because currently sleeping with eGPU crashes the system
        # on-timeout =
        #   "[ -L $XDG_CONFIG_HOME/hypr/egpu ] || ${config.wayland.suspend}";
      }
    ];

    # TODO cleaner with Nix modules, options
    wayland.windowManager.hyprland.settings.env =
      let var = config.home.sessionVariables;
      in [
        "NIXOS_OZONE_WL,1" # Force Wayland support for some apps (Chromium)
        "TERM,${config.term.cmd}" # Default terminal emulator
        "TERMINAL,${config.term.cmd}" # Default terminal emulator
        "TERM_EXEC,${config.term.exec}" # Default terminal exec command arg
        # FIX Set these variables again FIXME home.sessionVariables don’t get passed to Nushell
        "SHELL,${var.SHELL}" # Force default interactive shell
        "XDG_CONFIG_HOME,${var.XDG_CONFIG_HOME}" # Force default config loc
        "CONFIG_FLAKE,${var.CONFIG_FLAKE}" # System and home flake configs
        "EDITOR,${var.EDITOR}" # Force default editor
        "PAGER,${var.PAGER}" # Force default pager
        "PASSWORD_STORE_DIR,${var.PASSWORD_STORE_DIR}" # passwords location
        "BAT_PAGING,${var.BAT_PAGING}"
      ];
  };
}
