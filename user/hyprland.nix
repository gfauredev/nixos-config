{ inputs, lib, config, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    plugins = [ ];
    settings = { };
    systemdIntegration = true;
    xwayland.enable = true;
    extraConfig = ''
    '';
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
