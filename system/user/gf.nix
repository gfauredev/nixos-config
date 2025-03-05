{ ... }: {
  # TODO common user config for system/ and home/ in the flake.nix
  users.users.gf = {
    isNormalUser = true;
    home = "/home/gf";
    homeMode = "700";
    createHome = true;
    description = "Guilhem Fauré";
    useDefaultShell = true; # The only one allowed
    # shell = pkgs.dash;
    extraGroups = [
      "wheel" # sudo
      "networkmanager" # Manage networks
      "video"
      "audio"
      "realtime"
      "lp" # Manage printing & scanning
      "scanner" # Manage scanning
      "fuse" # Mount USB keys and other filesystems
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
    ];
  };

  users.groups = {
    mtp = { };
    uinput = { };
  };
}
