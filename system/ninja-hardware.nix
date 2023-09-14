# This is a TEMPLATE
# Replace UUIDs with actuals UUIDs
# Use ‘nixos-generate-config’ in case of hardware change & patch
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "uas"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  # boot.initrd.kernelModules = [ ];
  # boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  boot.initrd.luks.devices = {
    "cryptroot".device = "/dev/disk/by-uuid/UUID";
  };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "vfat";
    };

  # We can IGNORE everything BELOW
}
