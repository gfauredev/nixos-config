{ pkgs, ... }: {
  imports = [ ./launcher ];

  home.packages = with pkgs; [
    wlr-randr # Edit display settings for wayland
    nwg-displays # Arrange displays
    wl-clipboard # Copy from CLI
    hyprpicker # Better color picker
    grim # Take screenshots
    slurp # Select a screen zone with mouse
    wayvnc # Wayland remote desktop
    # waypipe # Send a wayland window through SSH
    # hyprpaper # Wallpaper engine
    # wev # Evaluate inputs sent to wayland
    # swww # Dynamic wallpaper
    # eww # Advanced widgets
  ];

  # services = {
  #   kanshi = {
  #     enable = true;
  #     profiles = {
  #       docked = {
  #         outputs = [
  #           {
  #             criteria = "eDP-1";
  #           }
  #         ];
  #       };
  #     };
  #     systemdTarget = "hyprland-session.target";
  #   };
  # };

  programs = {
    # Start window managers at login on firsts TTYs
    zsh.loginExtra = ''
      if [ -z "''${DISPLAY}" ]; then
        if [ "''${XDG_VTNR}" -eq 1 ]; then
          exec $HOME/.nix-profile/bin/Hyprland
        fi
        if [ "''${XDG_VTNR}" -eq 2 ]; then
          exec startx $HOME/.nix-profile/bin/i3
        fi
      fi
    '';
    swaylock = {
      enable = true;
      settings = { indicator-idle-visible = true; };
    };
    rofi.package = pkgs.rofi-wayland; # Set this for wayland
  };
}
