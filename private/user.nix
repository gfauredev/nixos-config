rec {
  users = rec {
    default = gf;
    gf = rec {
      name = "gf"; # Initials # Used by Home-Manager before NixOS sets it
      home = "/home/${name}"; # Used by Home-Manager before NixOS sets it
      isNormalUser = true;
      hashedPassword = "KEEP ENCRYPTED IN PRIVATE CONFIG"; # Mandatory for impermanence to work
      description = "Guilhem"; # Myself
      homeMode = "700"; # No permissions for others
      useDefaultShell = true; # The only one allowed
      group = "users"; # Primary (default) group
      extraGroups = [
        "wheel" # Act as root
        "fuse" # Mount USB keys and other filesystems
        "podman" # Use Podman container manager
        "…" # …
      ];
    };
  };
  emails = {
    gf = "me@mydoma.in"; # Email
  };
  default = users.default // {
    email = emails.${users.default.name};
  };
}
