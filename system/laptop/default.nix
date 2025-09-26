{
  lib,
  pkgs,
  config,
  ...
}: # Common configuration for laptops
{
  imports = [
    ../default.nix
    ../module/pc.nix
    ../module/i18n.nix
  ];

  services = {
    auto-cpufreq.enable = lib.mkDefault true; # Save battery, smarter than TLP
    thermald.enable = lib.mkDefault true; # Keep CPU cool
    tlp.enable = (!config.services.auto-cpufreq.enable); # Save battery
    fprintd.enable = lib.mkDefault true; # Support fingerprint readers
    localtimed.enable = lib.mkDefault true;
    # auto-cpufreq = { TODO
    #   settings = {
    #     battery = {
    #       governor = "powersave";
    #       turbo = "never";
    #     };
    #     charger = {
    #       governor = "performance";
    #       turbo = "auto";
    #     };
    #   };
    # };
    tlp = {
      settings = {
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 25;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        PCIE_ASPM_ON_BAT = "powersupersave";
        INTEL_GPU_MIN_FREQ_ON_AC = 500;
        INTEL_GPU_MIN_FREQ_ON_BAT = 400;
        START_CHARGE_THRESH_BAT0 = 30; # 30 and below: start to charge
        STOP_CHARGE_THRESH_BAT0 = 90; # 90 and above: don’t charge
      };
    };
    logind = {
      powerKey = "suspend";
      lidSwitch = "suspend";
      # settings.Login = {
      #   HandlePowerKey = "suspend";
      #   HandleLidSwitch = "suspend";
      # };
    };
    # getty.helpLine = ''
    #   tty1: Hyprland, on iGPU only (wayland window manager)
    #   tty2: Hyprland, on eGPU only (wayland window manager)
    #   tty3: Niri, to test (wayland window manager)'';
  };

  environment.systemPackages = [ pkgs.brightnessctl ]; # Keyboard brightness control
}
