{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./ninja-hardware.nix # Hardware specific conf
  ];

  hardware = {
    # cpu.intel.updateMicrocode = true; # TEST if set by hardware
    opengl = {
      enable = true;
      # driSupport = true; # TEST relevance
      # driSupport32Bit = true; # TEST relevance
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        # wireguard-go # VPN
      ];
    };
    sensor.iio.enable = true;
    uinput.enable = true;
  };

  boot = {
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
    bootspec.enable = true;
    loader.systemd-boot.enable = false; # Disabled for secureboot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    # initrd.postMountCommands = '' 
    #   umount /boot # FIXME
    # '';
  };

  networking = {
    hostName = "ninja";
    firewall = {
      # Syncthing:22000,21027 / Vagrant:2049
      allowedTCPPorts = [ 22000 2049 ]; # Opened TCP ports
      allowedUDPPorts = [ 22000 21027 2049 ]; # Open UDP ports
    };
    wireguard.enable = true;
  };

  security = {
    pam.services = {
      swaylock = { };
      # system-local-login.fprintAuth = true; # FIXME
      # login.fprintAuth = true; # FIXME
    };
  };

  services = {
    fwupd = {
      # extraRemotes = [ "lvfs-testing" ];
    };
    fprintd = {
      enable = true; # Support for figerprint reader # FIXME
      # tod = {
      #   enable = true; # Support for figerprint reader
      #   driver = pkgs.libfprint-2-tod1-goodix; # FIXME
      # };
    };
    # fstrim = { # TEST pertinence, should be set by hardware
    #   enable = true;
    # };
  };

  # system kind (needed for flakes)
  # nixpkgs.hostPlatform = "x86_64-linux"; # TEST pertinence with flake system
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
