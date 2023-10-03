{ inputs, lib, config, pkgs, ... }: {
  services = {
    xserver = {
      displayManager = {
        startx.enable = true;
        defaultSession = "none+i3";
      };
    };
  };
}
