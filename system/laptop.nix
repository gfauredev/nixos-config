{ inputs, lib, config, pkgs, ... }: {
  services.logind = {
    lidSwitch = "suspend";
    extraConfig = "HandlePowerKey=suspend";
  };

  powerManagement = {
    enable = true;
    # powertop.enable = true; # TODO: test relevance
    cpuFreqGovernor = "powersave";
  };

  programs = {
    light.enable = true;
  };

  # TODO: test relevance
  # environment.systemPackages = with pkgs; [
  #   iio-sensor-proxy
  #   libinput
  #   xorg.xf86videointel
  #   fprintd
  #   libfprint
  # ];
}
