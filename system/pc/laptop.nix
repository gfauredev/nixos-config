{ inputs, lib, config, pkgs, ... }: {
  services = {
    logind = {
      lidSwitch = "suspend";
      extraConfig = "HandlePowerKey=suspend";
    };
    localtimed.enable = true;
  };

  powerManagement = {
    enable = true;
    # powertop.enable = true; # TEST relevance
    cpuFreqGovernor = lib.mkDefault "powersave"; # TEST relevance
  };

  programs = {
    light.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # TEST relevance of each, take hardware into account
    # iio-sensor-proxy
    # libinput
    # xorg.xf86videointel
    # fprintd
    # libfprint
  ];
}
