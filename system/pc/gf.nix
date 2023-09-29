{ inputs, lib, config, pkgs, ... }: {
  users.users.gf = {
    isNormalUser = true;
    home = "/home/gf";
    homeMode = "700";
    createHome = true;
    description = "Guilhem Fauré";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "realtime"
      "lp"
      "scanner"
      "fuse"
      "uucp"
      "mtp"
      "libvirtd"
      "adbusers"
      "vboxusers"
      "docker"
      "uinput"
    ];
  };

  users.groups = {
    mtp = { };
  };
}
