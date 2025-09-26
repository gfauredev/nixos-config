{ ... }:
let
  cryptroot = "/dev/disk/by-uuid/436884c6-7982-407c-b213-8d034a22f466"; # mapper
  samsung980ssd.p1 = "/dev/disk/by-uuid/1D92-247E";
  samsung980ssd.p2 = "/dev/disk/by-uuid/7a87ac1f-33a3-415f-b339-2bba2c847c24";
in
{
  boot.initrd.luks.devices."cryptroot".device = cryptroot;

  fileSystems."/".device = samsung980ssd.p2;

  fileSystems."/home".device = samsung980ssd.p2;

  fileSystems."/log".device = samsung980ssd.p2;

  fileSystems."/nix".device = samsung980ssd.p2;

  fileSystems."/swap".device = samsung980ssd.p2;

  fileSystems."/boot".device = samsung980ssd.p1;

  fileSystems."/home/gf/code".device = samsung980ssd.p2;
}
