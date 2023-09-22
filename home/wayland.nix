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
    # TODO set with nix directly, or more cleanly
    zsh.loginExtra = ''
      # Start window managers at login on first TTYs
      if [ -z "''${DISPLAY}" ]; then
        if [ "''${XDG_VTNR}" -eq 1 ]; then
          exec $HOME/.nix-profile/bin/Hyprland
        fi
        if [ "''${XDG_VTNR}" -eq 2 ]; then
          exec $HOME/.nix-profile/bin/sway
        fi
      fi
    '';
    swaylock = {
      enable = true;
      settings = {
        indicator-idle-visible = true;
      };
    };
    rofi.package = pkgs.rofi-wayland; # Set this for wayland
  };
}
