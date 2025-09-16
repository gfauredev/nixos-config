# Common configuration for laptops
{ lib, pkgs, ... }:
{
  imports = [
    ../default.nix
    ../module/pc.nix
  ];

  # Limit threads usage of nix builds
  nix.settings.max-jobs = lib.mkDefault 8;

  # Forcefuly restrict nix-daemon memory usage TODO study and TEST
  systemd = {
    # Create a separate slice for nix-daemon that is
    # memory-managed by the userspace systemd-oomd killer
    # slices."nix-daemon".sliceConfig = {
    #   ManagedOOMMemoryPressure = "kill";
    #   ManagedOOMMemoryPressureLimit = "50%";
    # };
    # services."nix-daemon".serviceConfig.Slice = "nix-daemon.slice";
    # If a kernel-level OOM event does occur anyway,
    # strongly prefer killing nix-daemon child processes
    # services."nix-daemon".serviceConfig.OOMScoreAdjust = 1000;
  };

  hardware = {
    # sensor.iio.enable = lib.mkDefault true; # Auto brightness & orientation
    # brillo.enable = true; # Keyboard brightness control
  };

  services = {
    localtimed.enable = true;
    auto-cpufreq.enable = false; # to TEST
    thermald.enable = lib.mkDefault true; # Keep CPU cool
    tlp.enable = true; # Save battery
    fprintd.enable = lib.mkDefault true; # Support fingerprint readers
    auto-cpufreq = {
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
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
      settings.Login = {
        HandlePowerKey = "suspend";
        HandleLidSwitch = "suspend";
      };
    };
    # TODO link this to the actual login manager in home/wayland/
    getty.helpLine = ''
      tty1: Hyprland, on iGPU only (wayland window manager)
      tty2: Hyprland, on eGPU only (wayland window manager)
      tty3: Niri, to test (wayland window manager)'';
  };

  environment.systemPackages = [
    pkgs.brightnessctl # Keyboard brightness control
  ];
  # hardware.brillo.enable = true;
}
