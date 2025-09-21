{
  gf = rec {
    fullname = "Guilhem Fauré"; # Myself
    email = "pro@guilhemfau.re"; # Email
    # The following goes under users.users.
    config = rec {
      name = "gf"; # Initials
      description = fullname; # Myself
      home = "/home/${name}";
      # … in private config
    };
  };
}
