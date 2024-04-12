{ pkgs, ... }: {
  imports = [ ./hyprland ./waybar ./launcher ./remap ];

  home.packages = with pkgs; [
    wev # Evaluate inputs sent to wayland to debug
    wlr-randr # Edit display settings for wayland
    wl-clipboard # Copy from CLI
    hyprpicker # Better color picker
    grim # Take screenshots
    slurp # Select a screen zone with mouse
    wayvnc # Wayland remote desktop
    # waypipe # Send a wayland window through SSH
    # hyprpaper # Wallpaper engine
    # swww # Dynamic wallpaper
    # eww # Advanced widgets
    niri # Innovative WM infinity horizontal scroll
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
        fi
        if [ "$XDG_VTNR" -eq 3 ]; then
          exec $HOME/.nix-profile/bin/niri --session
        fi
      fi
    '';
    swaylock = {
      enable = true;
      settings.indicator-idle-visible = true;
    };
    rofi.package = pkgs.rofi-wayland; # Set this for wayland
  };
}
