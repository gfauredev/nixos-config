{ inputs, lib, config, pkgs, ... }: {
  services = {
    xserver = {
      # exportConfiguration = true; # TEST relevance
      displayManager = {
        startx.enable = true;
        defaultSession = "none+i3";
      };
    };
    xbanish.enable = true;
  };
}
