{ ... }:
{
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/";

  fileSystems."/".device = "/dev/disk/by-uuid/";

  fileSystems."/home".device = "/dev/disk/by-uuid/";

  fileSystems."/log".device = "/dev/disk/by-uuid/";

  fileSystems."/nix".device = "/dev/disk/by-uuid/";

  fileSystems."/boot".device = "/dev/disk/by-uuid/";
}
