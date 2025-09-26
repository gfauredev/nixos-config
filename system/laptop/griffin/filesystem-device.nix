{ ... }:
{
  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/436884c6-7982-407c-b213-8d034a22f466";

  fileSystems."/".device = "/dev/disk/by-uuid/7a87ac1f-33a3-415f-b339-2bba2c847c24";

  fileSystems."/home".device = "/dev/disk/by-uuid/7a87ac1f-33a3-415f-b339-2bba2c847c24";

  fileSystems."/log".device = "/dev/disk/by-uuid/7a87ac1f-33a3-415f-b339-2bba2c847c24";

  fileSystems."/nix".device = "/dev/disk/by-uuid/7a87ac1f-33a3-415f-b339-2bba2c847c24";

  fileSystems."/swap".device = "/dev/disk/by-uuid/7a87ac1f-33a3-415f-b339-2bba2c847c24";

  fileSystems."/boot".device = "/dev/disk/by-uuid/1D92-247E";
}
