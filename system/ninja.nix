# Everything that is strictly related to the ninja’s hardware

{ inputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # <nixos-hardware/framework> # This computer hardware specific
  ];

  ## Hardware ##
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "uas" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/95d2d844-008b-4c0e-a7b1-914b16db9888";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/99d1fcd1-6945-47ad-b7a1-e3ce08e02b42";

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/95d2d844-008b-4c0e-a7b1-914b16db9888";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/persist" =
    {
      device = "/dev/disk/by-uuid/95d2d844-008b-4c0e-a7b1-914b16db9888";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/95d2d844-008b-4c0e-a7b1-914b16db9888";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/8E04-C403";
      fsType = "vfat";
    };
  ## End hardware ##

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

  nix = {
    # add each flake input as a registry
    # To make nix3 commands consistent with flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    # add inputs to the system's legacy channels
    # Making legacy nix commands consistent as well
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
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

  security = {
    # TODO: fix
    # pam.services = {
    #   system-local-login.fprintAuth = true;
    #   # login.fprintAuth = true;
    # };
  };

  services = {
    # TODO: fix
    # fprintd = {
    #   enable = true; # Support for figerprint reader
    #   tod = {
    #     enable = true; # Support for figerprint reader
    #     driver = pkgs.libfprint-2-tod1-goodix;
    #   };
    # };
  };

  # system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
