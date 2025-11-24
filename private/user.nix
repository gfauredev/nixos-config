{
  users = {
    gf = rec {
      name = "gf"; # Initials # Used by Home-Manager before NixOS sets it
      home = "/home/${name}"; # Used by Home-Manager before NixOS sets it
      isNormalUser = true;
      hashedPassword = "SECRET🔒"; # For immutable users
      description = "Full Name";
      homeMode = "700"; # No permissions for others
      useDefaultShell = true; # The only one allowed
      extraGroups = [
        "lp" # Manage printing & scanning devices & configs
        "scanner" # Manage scanning
        "networkmanager" # Manage networks
      ];
    };
  };
  emails = {
    gf = "me@example.com"; # Primary email
  };
}
