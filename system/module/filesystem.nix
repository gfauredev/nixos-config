{ lib, ... }: # Default filesystems
let
  luksDev = "cryptroot";
in
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
    initrd.luks.devices.${luksDev}.device = lib.mkDefault "/dev/nvme0n1p2";
    resumeDevice = lib.mkDefault "/dev/mapper/${luksDev}"; # Use UUID=… instead
    # WARN Set resume_offset in kernelParams to allow resuming from swapfile
  };

  fileSystems = {
    "/" = {
      device = lib.mkDefault "/dev/mapper/${luksDev}"; # WARN Replace with UUID!
      fsType = "btrfs";
      options = [
        "subvol=root"
        "noexec" # Security hardening
        "noatime" # Reduce writes
        "compress=zstd" # Reduce writes and space usage
      ];
    };
    "/code" = {
      device = lib.mkDefault "/dev/mapper/${luksDev}"; # WARN Replace with UUID!
      fsType = "btrfs";
      options = [
        "subvol=code"
        "exec" # Allow users to execute code somewhere (TODO individual dirs gen)
        "nodev" # Security hardening
        "noatime" # Reduce writes
        "compress=zstd" # Reduce writes and space usage
      ];
    };
    "/home" = {
      device = lib.mkDefault "/dev/mapper/${luksDev}"; # WARN Replace with UUID!
      fsType = "btrfs";
      options = [
        "subvol=home"
        "noexec" # Security hardening
        "nodev" # Security hardening
        "nosuid" # Security hardening
        "noatime" # Reduce writes
        "compress=zstd" # Reduce writes and space usage
      ];
    };
    "/log" = {
      device = lib.mkDefault "/dev/mapper/${luksDev}"; # WARN Replace with UUID!
      fsType = "btrfs";
      options = [
        "subvol=log"
        "noexec" # Security hardening
        "nodev" # Security hardening
        "nosuid" # Security hardening
        "noatime" # Reduce writes
        "compress=zstd" # Reduce writes and space usage
      ];
    };
    "/nix" = {
      device = lib.mkDefault "/dev/mapper/${luksDev}"; # WARN Replace with UUID!
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "exec" # Just to be explicit
        "nodev" # Security hardening
        "nosuid" # Security hardening
        "noatime" # Reduce writes
        "compress=zstd" # Reduce writes and space usage
      ];
    };
    "/swap" = {
      device = lib.mkDefault "/dev/mapper/${luksDev}"; # WARN Replace with UUID!
      fsType = "btrfs";
      options = [
        "subvol=swap"
        "noexec" # Security hardening
        "nodev" # Security hardening
        "nosuid" # Security hardening
        "noatime" # Reduce writes
        "compress=zstd" # Reduce writes and space usage
      ];
    };
    "/tmp" = {
      device = lib.mkDefault "tmpfs";
      fsType = lib.mkDefault "tmpfs";
      options = [
        "defaults"
        "exec" # For Nix builds
        "nodev" # Security hardening
        "nosuid" # Security hardening
        "mode=1777"
        "size=6G"
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
