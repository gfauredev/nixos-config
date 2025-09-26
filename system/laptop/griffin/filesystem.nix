{ ... }: # Griffin’s filesystems
{
  imports = [ ./filesystem-device.nix ];

  boot.initrd.luks.devices."cryptroot" = { };

  fileSystems."/" = {
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
      "noatime"
      "noexec"
    ];
  };

  fileSystems."/home" = {
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
      "noatime"
      "noexec"
    ];
  };

  fileSystems."/log" = {
    fsType = "btrfs";
    options = [
      "subvol=log"
      "compress=zstd"
      "noatime"
      "noexec"
    ];
  };

  fileSystems."/nix" = {
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/swap" = {
    fsType = "btrfs";
    options = [
      "subvol=swap"
      "compress=lzo"
      "noatime"
      "noexec"
    ];
  };

  fileSystems."/boot" = {
    fsType = "vfat";
    options = [
      "noexec"
    ];
  };

  swapDevices = [
    {
      device = "/swap/swapfile"; # On the dedicated btrfs subvolume
      size = 16 * 1024 + 64; # A bit more than RAM size
    }
  ];
}
