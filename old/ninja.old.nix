{ config, pkgs, ... }:

{
  imports = [
    <nixos-hardware/framework> # This computer hardware specific
    ./gui.nix # main user settings, with graphical env
    ./virtualisation.nix # virtualisation setup
  ];

  networking = {
    hostName = "gfFrameworkLaptop"; # Define your hostname
    firewall.allowedTCPPorts = [ 22000 2049 ]; # Opened TCP ports firewall
    firewall.allowedUDPPorts = [ 22000 21027 2049 ]; # Open UDP ports in the firewall
    networkmanager = {
      enable = true;
      dns = "default";
    };
  };


  boot = {
    loader.efi.canTouchEfiVariables = true; # Don’t touch if buggy UEFI
    # kernelPackages = pkgs.linuxKernel.packages.linux_6_0;
    # pin a specific kernel version that works with this hardware
    # kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_0.override {
    #   argsOverride = rec {
    #     version = "6.0.7";
    #     modDirVersion = "6.0.7";
    #     src = pkgs.fetchurl {
    #       url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    #       # sha256 = "Z9rMK3hgWlbpl/TAjQCb6HyY7GbxhwIgImyLPMZ2WQ8=";# 6.0.7
    #     };
    #   };
    # });
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "nvme.noacpi=1"
      "i915.force_probe=4626"
    ];
    extraModprobeConfig = ''
      blacklist hid_sensor_hub
      options snd_usb_audio vid=0x1235 pid=0x8210 device_setup=1
    '';
  };

  services = {
    fprintd = {
      enable = true; # Support for figerprint reader
      tod = {
        enable = true; # Support for figerprint reader
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };
    fstrim = {
      enable = true;
    };
    fwupd.enable = true; # Update firmwares
    tlp.enable = true; # To save some power
    thermald.enable = true; # Try to keep cool
  };

  programs = {
    light.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    cpu.intel.updateMicrocode = true;
    opengl = {
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  security = {
    pam.services = {
      system-local-login.fprintAuth = true;
      # login.fprintAuth = true;
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  environment.systemPackages = with pkgs; [
    iio-sensor-proxy
    libinput
    xorg.xf86videointel
    fprintd
    libfprint
    # libinput-gestures # user geebar instead
  ];


  home-manager.users.gf = { config, pkgs, lib, ... }: {
    services = {
      cbatticon = {
        enable = true;
        lowLevelPercent = 30;
        # commandLowLevel = ''
        #   notify-send "LOW BATTERY"
        # '';
        criticalLevelPercent = 10;
        commandCriticalLevel = ''
          systemctl suspend
        '';
        hideNotification = true;
      };
      xsuspender = {
        enable = true;
      };
    };
  };

  system.stateVersion = "23.05";
}
