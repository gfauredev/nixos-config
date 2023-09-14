{ inputs, lib, config, pkgs, ... }: {
  services.logind = {
    lidSwitch = "suspend";
    extraConfig = "HandlePowerKey=suspend";
  };

  powerManagement = {
    cpuFreqGovernor = "powersave";
    # TODO: test relevance
    #   enable = true;
    #   powertop.enable = true;
  };
}
