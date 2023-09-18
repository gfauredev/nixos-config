{ inputs, lib, config, pkgs, ... }: {
  services = {
    # upower = { # TEST revelance, taking below udev rules into account
    #   enable = true;
    #   percentageLow = 30;
    #   percentageCritical = 20;
    #   percentageAction = 15;
    #   criticalPowerAction = "HybridSleep";
    # };
    udev = {
      enable = true;
      # TEST if below rules are working
      extraRules = ''
        SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="2[0-5]", RUN+="${pkgs.libnotify}/bin/notify-send 'LOW BATTERY'"

        SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="1[0-5]", RUN+="${pkgs.systemd}/bin/systemctl suspend"
      '';
    };
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
