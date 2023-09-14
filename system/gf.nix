{ inputs, lib, config, pkgs, ... }: {
  users.users.gf = {
    isNormalUser = true;
    home = "/home/gf";
    homeMode = "700";
    createHome = true;
    description = "Guilhem Fauré";
    # shell = pkgs.zsh; # TODO: verify pertinence with home-manager
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "realtime"
      "lp"
      "scanner"
      "smb"
      "fuse"
      "uucp"
      "mtp"
      "libvirt"
      "libvirtd"
      "adbusers"
      "vboxusers"
      "docker"
      "dialout"
      # "srv"
    ];
  };

  users.groups = {
    mtp = { };
    # srv = { };
  };
}
