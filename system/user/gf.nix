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
      "kvm" # In case
      "libvirt" # Use KVM hypervisor
      "libvirtd" # Use KVM hypervisor
      "vboxusers" # Use VirtualBox hypervisor
      "docker" # Use Docker container manager
      "podman" # Use Podman container manager
      "wireshark" # Use wireshark without root
      "keyd" # Use app-specific keyd remaps
      "config" # Configure system in /config WARNING depends of stateful permissions of /config
    ];
  };

  users.groups = {
    config = { }; # RWX in /config WARNING stateful perms of /config
    mtp = { };
    uinput = { };
  };
}
