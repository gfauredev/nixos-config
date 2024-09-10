{ pkgs, ... }: {
  imports = [ ./hyprland ./waybar ./launcher ./remap ];

  home.packages = with pkgs; [
    # wev # Evaluate inputs sent to wayland to debug
    # wlr-randr # Edit display settings for wayland
    wl-clipboard # Copy from CLI
    hyprpicker # Better color picker
    grim # Take screenshots
    slurp # Select a screen zone with mouse
    wayvnc # Wayland remote desktop
    # waypipe # Send a wayland window through SSH
    # hyprpaper # Wallpaper engine
    # swww # Dynamic wallpaper
    # eww # Advanced widgets
    # niri # Innovative WM infinity horizontal scroll
  ];

  xdg.dataFile."icons/Bibata-Hypr-Ice".source = ./Bibata-Modern-Ice.hyprcursor;

  home.sessionVariables = {
    HYPRCURSOR_THEME = "Bibata-Hypr-Ice"; # Modern cursor theme
    HYPRCURSOR_SIZE = "22";
  };

  programs = {
    # Start window managers at login on firsts TTYs
    zsh.loginExtra = ''
      if [ -z "$DISPLAY" ]; then
        if [ "$XDG_VTNR" -eq 1 ]; then
          exec $HOME/.nix-profile/bin/Hyprland
        elif [ "$XDG_VTNR" -eq 6 ]; then # Force use of eGPU
          exec WLR_DRM_DEVICES=$HOME/.config/hypr/egpu $HOME/.nix-profile/bin/Hyprland
        elif [ "$XDG_VTNR" -eq 9 ]; then
          exec $HOME/.nix-profile/bin/niri --session
        fi
      fi
    '';
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
    # swaylock = {
    #   enable = false;
    #   settings.indicator-idle-visible = true;
    # };
    rofi.package = pkgs.rofi-wayland; # Set this for wayland
  };
}
