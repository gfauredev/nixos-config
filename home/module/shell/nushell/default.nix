{ pkgs, ... }: {
  home.packages = [ pkgs.nu_scripts ]; # Additional community scripts
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    # TODO configure importing `use task.nu`
    extraConfig = ''
      $env.NU_LIB_DIRS = ($env.NU_LIB_DIRS
      | append ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/)'';
    settings = {
      rm.always_trash = true;
      show_banner = false;
    };
    plugins = with pkgs.nushellPlugins;
      [
        # skim # Fuzzy finder
        query # Query JSON, XML, web data
        # net # List network interfaces
        # dbus # Communicate with D-BUS
        # units # Convert between units
        # gstat # Git status
        # polars # Work with polars dataframes
        # formats # Convert eml, ics, ini, vcf to Nushell tables
        # highlight # Syntax highlighting (like bat)
      ];
  };
  services = {
    gpg-agent.enableNushellIntegration = true;
    # keychain.enableNushellIntegration = true; # TEST me
  };
  programs = {
    starship.enableNushellIntegration = true;
    zoxide.enableNushellIntegration = true;
    broot.enableNushellIntegration = true;
    atuin.enableNushellIntegration = true;
    carapace.enableNushellIntegration = false; # TODO configure, add to fish’s
    direnv.enableNushellIntegration = true;
    eza.enableNushellIntegration = false;
  };
}
