{ lib, pkgs, ... }: {
  imports = [ ../default.nix ];

  hardware = {
    sensor.iio.enable = lib.mkDefault true; # Auto brightness & orientation
    # brillo.enable = true; # Keyboard brightness control
  };

  services = {
    logind = {
      lidSwitch = "suspend";
      extraConfig = "HandlePowerKey=suspend";
    };
    localtimed.enable = true;
    tlp.settings.PCIE_ASPM_ON_BAT = "powersupersave";
  };

  powerManagement = {
    enable = true;
    powertop.enable = true; # TEST relevance along powertop package
    cpuFreqGovernor = lib.mkForce "powersave";
  };

  # programs.light.enable = true; # DEPRECATED

  environment.systemPackages = with pkgs;
    [
      brightnessctl # Keyboard brightness control
    ];
}
