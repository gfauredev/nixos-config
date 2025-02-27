{ ... }: {
  programs.nushell = {
    enable = true; # TODO configure
    # See : https://www.nushell.sh/book/getting_started.html
    # configFile.source = ./config.nu;
    # envFile.source = ./env.nu;
    # loginFile.source = ./login.nu;
  };
}
