{ lib, ... }: {
  imports = [ ../default.nix ];

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

  programs.light.enable = true;
}
