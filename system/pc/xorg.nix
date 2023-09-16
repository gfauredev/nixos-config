{ inputs, lib, config, pkgs, ... }: {
  packages = with pkgs; [
    # xbanish # Hide mouse Xorg
  ];

  services = {
    xserver = {
      enable = true;
      autorun = false;
      layout = "fr,us,fr";
      xkbVariant = "bepo_afnor,,";
      xkbOptions = "grp:ctrls_toggle";
      dpi = 144;
      # exportConfiguration = true; # TEST relevance
      # libinput.enable = true; # Enable touchpad support
      displayManager = {
        startx.enable = true;
        defaultSession = "none+i3";
      };
      desktopManager.xterm.enable = false;
    };
    # xbanish.enable = true;
    # gnome.gnome-keyring.enable = true;
    # flatpak.enable = true;
  };
}
