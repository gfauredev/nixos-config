{ lib, ... }: # Default filesystems
{
  boot.initrd.luks.devices."cryptroot".device = lib.mkDefault "/dev/nvme0n1p2";

  fileSystems = {
    "/" = {
      device = lib.mkDefault "/dev/mapper/cryptroot"; # WARN Replace with UUID !
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
        "noatime"
        "noexec" # WARNING Some (glibc-locales) builds seemingly need to execute scripts outside /nix
      ];
    };

    "/boot" = {
      device = lib.mkDefault "/dev/nvme0n1p1"; # WARN Replace by machine’s UUIDs
      fsType = "vfat";
      options = [
        "noexec"
        "fmask=0022" # TODO may be hardenable
        "dmask=0022"
      ];
    };

    "/code" = {
      device = lib.mkDefault "/dev/mapper/cryptroot"; # WARN Replace with UUID !
      fsType = "btrfs";
      options = [
        "subvol=/code"
        "compress=zstd"
        "noatime"
        "exec" # Allow users to execute code somewhere (TODO individual dirs gen)
      ];
    };

    "/home" = {
      device = lib.mkDefault "/dev/mapper/cryptroot"; # WARN Replace with UUID !
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd"
        "noatime"
        "noexec" # Security hardening
      ];
    };

    "/log" = {
      device = lib.mkDefault "/dev/mapper/cryptroot"; # WARN Replace with UUID !
      fsType = "btrfs";
      options = [
        "subvol=log"
        "compress=zstd"
        "noatime"
        "noexec"
      ];
    };

    "/nix" = {
      device = lib.mkDefault "/dev/mapper/cryptroot"; # WARN Replace with UUID !
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd"
        "noatime"
      ];
    };

    "/swap" = {
      device = lib.mkDefault "/dev/mapper/cryptroot"; # WARN Replace with UUID !
      fsType = "btrfs";
      options = [
        "subvol=swap"
        "compress=zstd"
        "noatime"
        "noexec"
      ];
    };
  };

  # swapDevices = [ FIXME
  #   {
  #     device = "/swap/swapfile"; # On the dedicated btrfs subvolume
  #     size = 16 * 1024 + 64; # A bit more than RAM size
  #   }
  # ];
}
