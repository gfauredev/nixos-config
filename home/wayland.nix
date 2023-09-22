{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    wlr-randr # Edit display settings for wayland
    wl-clipboard # Copy from CLI
    hyprpicker # Better color picker
    grim # Take screenshots
    slurp # Select a screen zone with mouse
    wev # Evaluate inputs to wayland
    # eww
  ];
}
