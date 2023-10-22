{ inputs, lib, config, pkgs, ... }: {
  services = {
    # upower = { # TEST revelance, taking below udev rules into account
    #   enable = true;
    #   percentageLow = 30;
    #   percentageCritical = 20;
    #   percentageAction = 15;
    #   criticalPowerAction = "HybridSleep";
    # };
    # udev = {
    #   enable = true;
    #   extraRules = ''
    #     SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="2[0-5]", RUN+="${pkgs.libnotify}/bin/notify-send 'LOW BATTERY' 'Battery below 25%'"
    #
    #     SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="1[0-5]", RUN+="${pkgs.systemd}/bin/systemctl suspend"
    #   '';
    # };
    logind = {
      lidSwitch = "suspend";
      extraConfig = "HandlePowerKey=suspend";
    };
    localtimed.enable = true;
    tlp = {
      # enable = true; # Useless, enabled by powerManagement
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave"; # Might be only for ninja
        # START_CHARGE_THRESH_BAT0 = 75; # Don’t start charging above
        # STOP_CHARGE_THRESH_BAT0 = 80; # Don’t charge above # FIXME
        # START_CHARGE_THRESH_BAT1 = 75; # Don’t start charging above
        # STOP_CHARGE_THRESH_BAT1 = 80; # Don’t charge above # FIXME
      };
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = true; # TEST relevance along powertop package
    cpuFreqGovernor = lib.mkForce "powersave";
  };

  programs = {
    light.enable = true;
  };

  environment.systemPackages = with pkgs; [
    powertop
  ];
}
