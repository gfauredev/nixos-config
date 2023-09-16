# Use `nixos-generate-config --root /mnt` during install.
# The correct the resulting `/mnt/etc/nixos/hardware-config.nix`
# with informations from this file.

{ config, lib, pkgs, ... }: {
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  boot.initrd.luks.devices = {
    "cryptroot".device = "/dev/disk/by-uuid/UUID";
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };
  };
  # We can IGNORE everything BELOW
}
