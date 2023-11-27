{ inputs, lib, config, pkgs, ... }: {
  users.users.gf = {
    isNormalUser = true;
    home = "/home/gf";
    homeMode = "700";
    createHome = true;
    description = "Guilhem Fauré";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # Sudo
      "networkmanager"
      "video"
      "audio"
      "realtime"
      "lp"
      "scanner"
      "fuse"
      "uucp" # Connect to serial ports
      "dialout" # Connect to serial ports
      "mtp"
      "libvirtd"
      "adbusers" # Connect to Android devices
      "vboxusers"
      "docker"
      "uinput"
      "wireshark" # Use wireshark without root
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
