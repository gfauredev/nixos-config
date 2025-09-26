{ ... }:
{
  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/2965fedd-fe24-4b7d-90eb-1725ce0ffa32";

  fileSystems."/".device = "/dev/disk/by-uuid/3a770357-029a-4047-b1e5-3a9951e83f24";

  fileSystems."/home".device = "/dev/disk/by-uuid/3a770357-029a-4047-b1e5-3a9951e83f24";

  fileSystems."/log".device = "/dev/disk/by-uuid/";

  fileSystems."/nix".device = "/dev/disk/by-uuid/3a770357-029a-4047-b1e5-3a9951e83f24";

  fileSystems."/swap".device = "/dev/disk/by-uuid/";

  fileSystems."/boot".device = "/dev/disk/by-uuid/F226-8C9D";
}
