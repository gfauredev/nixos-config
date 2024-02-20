{ ... }: {
  services = {
    xserver = {
      displayManager = {
        startx.enable = true;
        defaultSession = "none+i3";
      };
    };
  };
}
