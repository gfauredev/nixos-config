{ lib, ... }: # Default filesystems
{
  fileSystems."/boot" = {
    device = lib.mkDefault "/dev/nvme0n1p1"; # WARN Replace by actual part UUID
    fsType = "vfat";
    options = [
      "noexec"
      "uid=0" # Ensure everything in the partition belongs to root
      "gid=0" # Ensure everything in the partition belongs to root
      "umask=077" # Make root the only one able to read or write into it
    ];
  };
  boot = {
    initrd.luks.devices."cryptroot".device = lib.mkDefault "/dev/nvme0n1p2";
    resumeDevice = lib.mkDefault "/dev/mapper/cryptroot"; # WARN use UUID=…
    # WARN set the resume_offset kernel param to allow resuming from swapfile
  };
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

    "/code" = {
      device = lib.mkDefault "/dev/mapper/cryptroot"; # WARN Replace with UUID !
      fsType = "btrfs";
      options = [
        "subvol=code"
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
        "exec" # Just to be explicit
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

  swapDevices = [
    {
      device = "/swap/swapfile"; # On the dedicated btrfs subvolume
      size = 16 * 1024 + 64; # Megabytes # A bit more than RAM size
    }
  ];
}
