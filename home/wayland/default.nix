{ pkgs, ... }: {
  imports = [ ./hyprland ./waybar ./launcher ./remap ];

  home.packages = with pkgs; [
    wev # Evaluate inputs sent to wayland to debug
    wl-clipboard # Copy from CLI
    hyprpicker # Better color picker
    grim # Take screenshots
    slurp # Select a screen zone with mouse
    # wayvnc # Wayland remote desktop
    # wlr-randr # Edit display settings for wayland
    # waypipe # Send a wayland window through SSH
    # hyprpaper # Wallpaper engine
    # swww # Dynamic wallpaper
    # eww # Advanced widgets
    # niri # Innovative WM infinity horizontal scroll
    # wayland # wayland lib
    # wayland-utils # wayland inffo
    # wayland-protocols # wayland protocol extensions
  ];

  xdg.dataFile."icons/Bibata-Hypr-Ice".source = ./Bibata-Modern-Ice.hyprcursor;

  home.sessionVariables = {
    HYPRCURSOR_THEME = "Bibata-Hypr-Ice"; # Modern cursor theme
    HYPRCURSOR_SIZE = "22";
  };

  programs = {
    # Start window managers at login on firsts TTYs
    zsh.loginExtra = builtins.readFile ./loginManager.sh;
    hyprlock = {
      enable = true;
      settings = {
        background = [{
          path = "screenshot";
          blur_passes = 2;
          blur_size = 3;
        }];
        input-field = [{
          monitor = "";
          size = "250, 50";
          outline_thickness = 2;
          dots_size = 0.35;
          dots_spacing = 0.15;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgb(000000)";
          inner_color = "rgb(000000)";
          font_color = "rgb(ffddcc)";
          fade_on_empty = true;
          fade_timeout = 2000;
          placeholder_text = "$PROMPT";
          hide_input = false;
          check_color = "rgb(b6a482)";
          fail_color = "rgb(fe4321)";
          fail_text = "$FAIL ($ATTEMPTS)";
          fail_transition = 300;
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1;
          position = "0, 0";
          halign = "center";
          valign = "center";
          # invert_numlock = false;
          # swap_font_color = false;
        }];
      };
    };
    rofi.package = pkgs.rofi-wayland; # Set this for wayland
  };

  services.hypridle.settings.listener = [
    {
      timeout = 300; # Lock session, (blur and dim screen)
      on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
      # on-timeout = "${pkgs.systemd}/bin/loginctl lock-session"; # FIXME tends to stop working
    }
    # {
    #   timeout = 300; # Dim screen
    #   on-timeout = "brightnessctl set 1%";
    # }
    {
      timeout = 600; # Put the computer to sleep
      # on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
      # NOTE hacky way to prevent sleep if eGPU connected TODO find a cleaner way :
      on-timeout =
        "[ -e $XDG_CONFIG_HOME/hypr/egpu ] || ${pkgs.systemd}/bin/systemctl suspend";
      # on-resume = "hyprctl dispatch dpms on";
    }
  ];
}
