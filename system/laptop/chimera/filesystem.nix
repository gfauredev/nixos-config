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
      # "noexec"
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

  fileSystems."/boot" = {
    fsType = "vfat";
    options = [
      "noexec"
    ];
  };
}
