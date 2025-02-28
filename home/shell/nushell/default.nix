{ pkgs, ... }: {
  programs.nushell = {
    enable = true;
    # See https://www.nushell.sh/book/getting_started.html
    # See https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.configFile
    configFile.source = ./config.nu;
    # envFile.source = ./env.nu; # TODO
    # loginFile.source = ./login.nu; # TODO
    plugins = with pkgs.nushellPlugins; [ # FIXME plugins don’t build
      # net # List network interfaces
      skim # Fuzzy finder
      # dbus # Communicate with D-BUS
      # units # Convert between units
      # query # Query JSON, XML, web data
      gstat # Git status
      # polars # Work with polars dataframes
      # formats # Convert eml, ics, ini, vcf to Nushell tables
      # highlight # Syntax highlighting (like bat)
    ];
  };
}
