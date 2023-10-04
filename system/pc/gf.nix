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
    uinput = { };
  };

  # TODO place these in user config
  # age = {
  #   identityPaths = [ /home/gf/.ssh/id_ed25519 ];
  #   secrets = {
  #     pro-email = {
  #       file = ../../secrets/secret1.age;
  #       owner = "gf";
  #       group = "users";
  #       mode = "440";
  #     };
  #   };
  # };
}
