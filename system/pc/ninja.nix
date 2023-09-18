{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./ninja-hardware.nix # Hardware specific conf
  ];

  hardware = {
    # cpu.intel.updateMicrocode = true; # TEST if set by hardware
    opengl = {
      enable = true; # TEST relevance
      # driSupport = true; # TEST relevance
      # driSupport32Bit = true; # TEST relevance
      #   extraPackages = with pkgs; [ # TEST relevance
      #     intel-media-driver
      #     vaapiIntel
      #     vaapiVdpau
      #     libvdpau-va-gl
      #   ];
    };
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
    # bootspec.enable = true; # TODO secureboot
    # loader.systemd-boot.enable = false; # Disable for secureboot
    # lanzaboote = {
    #   enable = true; # TODO secureboot
    #   pkiBundle = "/etc/secureboot";
    # };
  };

  networking = {
    hostName = "ninja";
    firewall = {
      allowedTCPPorts = [ 22000 2049 ]; # Opened TCP ports
      allowedUDPPorts = [ 22000 21027 2049 ]; # Open UDP ports
    };
  };

  security = {
    pam.services = {
      swaylock = { };
      # system-local-login.fprintAuth = true; # FIXME
      # login.fprintAuth = true;
    };
  };

  services = {
    # fprintd = { # FIXME
    #   enable = true; # Support for figerprint reader
    #   tod = {
    #     enable = true; # Support for figerprint reader
    #     driver = pkgs.libfprint-2-tod1-goodix;
    #   };
    # };
    # fstrim = { # TEST pertinence, should be set by hardware
    #   enable = true;
    # };
    # tlp.enable = true; # To save some power
    # thermald.enable = true; # Try to keep cool
  };

  # system kind (needed for flakes)
  # nixpkgs.hostPlatform = "x86_64-linux"; # TEST pertinence with flake system

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
