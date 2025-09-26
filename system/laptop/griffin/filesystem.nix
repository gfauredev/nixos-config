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
      "noexec" # WARNING Some (glibc-locales) builds seemingly need to execute scripts outside /nix
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
      "compress=zstd"
      "noatime"
      "noexec"
    ];
  };

  fileSystems."/boot" = {
    fsType = "vfat";
    options = [
      "noexec"
      "fmask=0022" # TODO may be hardenable
      "dmask=0022"
    ];
  };

  fileSystems."/home/gf/code" = {
    fsType = "btrfs";
    options = [
      "subvol=home/gf/code"
      "compress=zstd"
      "noatime"
      "exec" # Allow gf to execute some code in his home
    ];
  };

  # swapDevices = [ FIXME
  #   {
  #     device = "/swap/swapfile"; # On the dedicated btrfs subvolume
  #     size = 16 * 1024 + 64; # A bit more than RAM size
  #   }
  # ];
}
