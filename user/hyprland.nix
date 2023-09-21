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
}
