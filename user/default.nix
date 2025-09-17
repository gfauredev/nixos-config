{
  gf = rec {
    fullname = "Guilhem Fauré"; # Myself
    email = "pro@guilhemfau.re"; # Email
    # The following goes under users.users.
    config = rec {
      name = "gf"; # Initials
      description = fullname; # Myself
      home = "/home/${name}";
      homeMode = "700"; # No permissions for others
      isNormalUser = true;
      createHome = true;
      useDefaultShell = true; # The only one allowed
      extraGroups = [
        "wheel" # Act as root
        "adbusers" # Connect to Android devices
        # "audio" # Not sure ?
        "dialout" # Connect to serial ports
        "docker" # Use Docker container manager
        "fuse" # Mount USB keys and other filesystems
        "keyd" # Use app-specific keyd remaps
        "kvm" # In case
        "libvirt" # Use KVM hypervisor
        "libvirtd" # Use KVM hypervisor
        "lp" # Manage printing & scanning devices & configs
        "networkmanager" # Manage networks
        "podman" # Use Podman container manager
        "realtime" # Preempt CPU for real time
        "scanner" # Manage scanning
        "uucp" # Connect to serial ports
        "vboxusers" # Use VirtualBox hypervisor
        # "video" # Not sure ?
        "wireshark" # Use wireshark without root
        # Custom groups
        "mtp" # Transfer files with Android devices
        "uinput" # Use uinput devices
        "wg" # WireGuard without sudo
      ];
    };
  };
}
