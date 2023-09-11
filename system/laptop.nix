{ inputs, lib, config, pkgs, ... }: {
  powerManagement = {
    cpuFreqGovernor = "powersave";
    # TODO: test relevance
    #   enable = true;
    #   powertop.enable = true;
  };
}
