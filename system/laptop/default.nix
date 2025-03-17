# Common configuration for laptops
{ lib, pkgs, ... }: {
  imports = [ ../default.nix ../module/pc.nix ];

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
    sensor.iio.enable = lib.mkDefault true; # Auto brightness & orientation
    # brillo.enable = true; # Keyboard brightness control
  };

  services = {
    localtimed.enable = true;
    tlp = {
      enable = true;
      settings.PCIE_ASPM_ON_BAT = "powersupersave";
    };
    fprintd.enable = lib.mkDefault true; # Support fingerprint readers
    logind = {
      lidSwitch = "suspend";
      extraConfig = "HandlePowerKey=suspend";
    };
    # TODO link this to the actual login manager in home/wayland/
    getty.helpLine = ''
      tty1: Hyprland, on iGPU only (wayland window manager)
      tty2: Hyprland, on eGPU only (wayland window manager)
      tty3: Niri, to test (wayland window manager)'';
  };

  powerManagement = {
    enable = true;
    # powertop.enable = true; # TEST relevance along powertop package
    cpuFreqGovernor = lib.mkForce "powersave";
  };

  environment.systemPackages = [
    pkgs.brightnessctl # Keyboard brightness control
  ];
  # hardware.brillo.enable = true;
}
