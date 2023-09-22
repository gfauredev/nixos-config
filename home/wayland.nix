{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    wlr-randr # Edit display settings for wayland
    wl-clipboard # Copy from CLI
    hyprpicker # Better color picker
    grim # Take screenshots
    slurp # Select a screen zone with mouse
    wev # Evaluate inputs to wayland
  ];

  programs = {
    swaylock = {
      enable = true;
      settings = {
        indicator-idle-visible = true;
      };
    };
    rofi.package = pkgs.rofi-wayland; # Set this for wayland
  };
}
