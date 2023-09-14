{ inputs, lib, config, pkgs, ... }: {
  home = {
    services = {
      cbatticon = {
        enable = true;
        lowLevelPercent = 30;
        commandLowLevel = ''
          notify-send "LOW BATTERY"
        '';
        criticalLevelPercent = 10;
        commandCriticalLevel = ''
          systemctl suspend
        '';
        hideNotification = true;
      };
      # xsuspender = {
      #   enable = true;
      # };
    };
  };
}
