{ pkgs, ... }: {
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    # envFile.source = ./env.nu; # TODO
    plugins = with pkgs.nushellPlugins; # FIXME plugins don’t build
      [
        # net # List network interfaces
        skim # Fuzzy finder
        # dbus # Communicate with D-BUS
        # units # Convert between units
        # query # Query JSON, XML, web data
        # gstat # Git status
        # polars # Work with polars dataframes
        # formats # Convert eml, ics, ini, vcf to Nushell tables
        # highlight # Syntax highlighting (like bat)
      ];
  };
}
