{ inputs, lib, config, pkgs, ... }: {
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
    # cpu.intel.updateMicrocode = true; # TEST if set by hardware
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
    # kernelParams = [ # TEST if relevant
    #   "quiet"
    #   "udev.log_level=3"
    #   "nvme.noacpi=1"
    #   "i915.force_probe=4626"
    # ];
    # extraModprobeConfig = '' # TEST if relevant
    #   blacklist hid_sensor_hub
    # # Line below is used for Focusrite sound interfaces
    #   options snd_usb_audio vid=0x1235 pid=0x8210 device_setup=1
    # '';
  };

  networking = {
    # hostName = "ninja"; # TEST if set by the flake.nix
    firewall = {
      allowedTCPPorts = [ 22000 2049 ]; # Opened TCP ports
      allowedUDPPorts = [ 22000 21027 2049 ]; # Open UDP ports
    };
  };

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
    # fstrim = {
    #   enable = true;
    # };
    fwupd.enable = true; # Update firmwares
    # tlp.enable = true; # To save some power
    # thermald.enable = true; # Try to keep cool
    geoclue2 = {
      enable = true;
    };
  };

  location.provider = "geoclue2";

  # system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
