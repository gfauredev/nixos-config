{ lib, ... }: {
  programs = {
    alacritty = {
      enable = true; # Fast terminal emulator
      # See https://alacritty.org/config-alacritty.html
      settings = {
        general.live_config_reload = false;
        window.padding = {
          x = 2;
          y = 2;
        };
        colors.primary.background = lib.mkForce "#000000";
      };
    };
  };
}
