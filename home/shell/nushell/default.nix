{ ... }: {
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    # FIXME plugins don’t build
    # plugins = with pkgs.nushellPlugins; [
    #   net # List network interfaces
    #   skim # Fuzzy finder
    #   dbus # Communicate with D-BUS
    #   units # Convert between units
    #   query # Query JSON, XML, web data
    #   gstat # Git status
    #   polars # Work with polars dataframes
    #   formats # Convert eml, ics, ini, vcf to Nushell tables
    #   highlight # Syntax highlighting (like bat)
    # ];
    settings = {
      rm.always_trash = true;
      show_banner = false;
    };
  };
}
