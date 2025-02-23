{ lib, pkgs, ... }: {
  imports = [ ../default.nix ];

  hardware = {
    sensor.iio.enable = lib.mkDefault true; # Auto brightness & orientation
    # brillo.enable = true; # Keyboard brightness control
  };

  services = {
    localtimed.enable = true;
    tlp = {
      enable = true;
      settings.PCIE_ASPM_ON_BAT = "powersupersave";
    };
    fprintd.enable = lib.mkDefault true; # Support figerprint reader
    logind = {
      lidSwitch = "suspend";
      extraConfig = "HandlePowerKey=suspend";
    };
    getty.helpLine = ''
      tty1: Hyprland (wayland window manager)
      tty4: Hyprland, force eGPU
      tty5: Niri (experimental wayland window manager)
    ''; # TODO link this to the actual login manager in home/wayland/
  };

  powerManagement = {
    enable = true;
    # powertop.enable = true; # TEST relevance along powertop package
    cpuFreqGovernor = lib.mkForce "powersave";
  };

  # programs.light.enable = true; # DEPRECATED

  environment.systemPackages = with pkgs;
    [
      brightnessctl # Keyboard brightness control
    ];
}
