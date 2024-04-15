# BcacheFS partitioning TEMPLATE TODO this template
# Use `nixos-generate-config --root /mnt` during install,
# then correct the resulting `/mnt/etc/nixos/hardware-config.nix`
# to match this template (notably replace UUIDs)

{ ... }: {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/UUID";
    fsType = "bcachefs";
    # options = [ "subvol=root" "compress=zstd" "noatime" ];
  };

  # boot.initrd.luks.devices = { "cryptroot".device = "/dev/disk/by-uuid/UUID"; };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "bcachefs";
      # options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/UUID";
      fsType = "bcachefs";
      # options = [ "subvol=home" "compress=zstd" "noatime" ];
    };
  };
}
