{ pkgs, ... }: {
  home.packages = [ pkgs.nu_scripts ]; # Additional community scripts
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    extraConfig = ''
      $env.NU_LIB_DIRS = ($env.NU_LIB_DIRS
      | append ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/)
      use task.nu
    '';
    settings = {
      rm.always_trash = true;
      show_banner = false;
    };
    starship.enableNushellIntegration = true;
    zoxide.enableNushellIntegration = true;
    broot.enableNushellIntegration = true;
    atuin.enableNushellIntegration = true;
    carapace.enableNushellIntegration = true;
    direnv.enableNushellIntegration = true;
    eza.enableNushellIntegration = false;
    gpg-agent.enableNushellIntegration = true;
    # keychain.enableNushellIntegration = true; # TEST me
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
  };
}
