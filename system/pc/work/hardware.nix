# WARNING THIS IS JUST A FORMATTING TEMPLATE/EXAMPLE
{ config, lib, modulesPath, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/UUID";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime" ];
  };

  # boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/UUID";

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/UUID";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/UUID";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/UUID";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
