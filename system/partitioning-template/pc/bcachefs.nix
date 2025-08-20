# BcacheFS partitioning TEMPLATE TODO this template
# Use `nixos-generate-config --root /mnt` during install,
# then correct the resulting `/mnt/etc/nixos/hardware-config.nix`
# to match this template (notably replace UUIDs)

{ ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/UUID";
    fsType = "bcachefs";
    options = [ "compression=zstd" ];
  };

  # TODO use bcachefs’s encryption : bcachefs format --encrypted /dev/????
  # boot.initrd.luks.devices = { "cryptroot".device = "/dev/disk/by-uuid/UUID"; };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "bcachefs";
      options = [ "compression=zstd" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "bcachefs";
      options = [ "compression=zstd" ];
    };
  };
}
