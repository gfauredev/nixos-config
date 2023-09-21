{ inputs, lib, config, pkgs, ... }: {
  # TODO create a wayland common config along with sway
  home.packages = with pkgs; [
    hyprpaper # Wallpaper engine
    # swww # Dynamic wallpaper
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    plugins = [ ];
    settings = {
      "$mod" = "SUPER";

      bind = [
        "$mod, RETURN, exec, ${pkgs.wezterm}/bin/wezterm start --always-new-process"
        "$mod, SPACE, exec, rofi -show-icons -show combi -combi-modes 'drun, window, run, emoji'"
      ];
    };
    # systemdIntegration = true; # TEST relevance
    xwayland.enable = true;
    # extraConfig = ''
    # '';
  };

  programs = {
    # TODO set with nix directly, or more cleanly
    zsh.loginExtra = ''
      # Start window managers at login on first TTYs
      if [ -z "''${DISPLAY}" ]; then
        if [ "''${XDG_VTNR}" -eq 2 ]; then
          exec $HOME/.nix-profile/bin/Hyprland
        fi
      fi
    '';
  };
}
