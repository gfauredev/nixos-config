{ inputs, lib, config, pkgs, ... }: {
  packages = with pkgs; [
    # xbanish # Hide mouse Xorg
  ];

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
