{ pkgs, ... }: {
  users.users.gf = {
    isNormalUser = true;
    home = "/home/gf";
    homeMode = "700";
    createHome = true;
    description = "Guilhem Fauré";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # sudo
      "networkmanager" # Manage networks
      "video"
      "audio"
      "realtime"
      "lp" # Manage printing & scanning
      "scanner" # Manage scanning
      "fuse"
      "uucp" # Connect to serial ports
      "dialout" # Connect to serial ports
      "mtp" # Transfer files with Android devices
      "adbusers" # Connect to Android devices
      "uinput"
      "libvirt" # Use KVM hypervisor
      "libvirtd" # Use KVM hypervisor
      "vboxusers" # Use VirtualBox hypervisor
      "docker" # Use Docker container manager
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
