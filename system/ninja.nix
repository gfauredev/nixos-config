# Everything that is strictly related to the ninja’s hardware
{ inputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # <nixos-hardware/framework> # This computer hardware specific

    /etc/nixos/hardware-configuration.nix # Hardware specific conf
  ];

  nixpkgs = {
    overlays = [
      # use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    # TODO: ensure relevance
    # opengl = {
    #   extraPackages = with pkgs; [
    #     intel-media-driver
    #     vaapiIntel
    #     vaapiVdpau
    #     libvdpau-va-gl
    #   ];
    # };
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    consoleLogLevel = 0;
    kernel.sysctl = { "kernel.sysrq" = 176; }; # SysRq magic keys
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

  # TODO: Use the hostname in the flake.nix
  networking = {
    hostName = "ninja";
    firewall = {
      allowedTCPPorts = [ 22000 2049 ]; # Opened TCP ports
      allowedUDPPorts = [ 22000 21027 2049 ]; # Open UDP ports
    };
    networkmanager = {
      enable = true;
      # dns = "default";
    };
  };

  location.provider = "geoclue2";

  security = {
    # TODO: fix fprint login
    # pam.services = {
    #   system-local-login.fprintAuth = true;
    #   # login.fprintAuth = true;
    # };
  };

  services = {
    # TODO: fix fprint login
    # fprintd = {
    #   enable = true; # Support for figerprint reader
    #   tod = {
    #     enable = true; # Support for figerprint reader
    #     driver = pkgs.libfprint-2-tod1-goodix;
    #   };
    # };
    fstrim = {
      enable = true;
    };
    fwupd.enable = true; # Update firmwares
    # tlp.enable = true; # To save some power
    # thermald.enable = true; # Try to keep cool
    geoclue2 = {
      enable = true;
    };
  };

  # system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
