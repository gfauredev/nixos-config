{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nu_scripts # Additional community scripts
    nufmt # Nushell formatter
  ];
  programs.nushell.enable = true;
  programs.nushell = {
    configFile.source = ./config.nu;
    environmentVariables = config.home.sessionVariables // {
      PROMPT_COMMAND_RIGHT = ""; # Remove date & time from Nushell prompt
    };
    settings = {
      rm.always_trash = true;
      show_banner = false;
    };
    plugins = with pkgs.nushellPlugins; [
      skim # Fuzzy finder
      query # Query JSON, XML, web data
      # net # List network interfaces
      # dbus # Communicate with D-BUS
      # units # Convert between units
      gstat # Git status
      polars # Work with polars dataframes
      formats # Convert eml, ics, ini, vcf to Nushell tables
      # highlight # Syntax highlighting (like bat)
    ];
  };
  services = {
    gpg-agent.enableNushellIntegration = true;
    # keychain.enableNushellIntegration = true; FIXME
  };
  programs = {
    zoxide.enableNushellIntegration = true;
    broot.enableNushellIntegration = true;
    atuin.enableNushellIntegration = true;
    carapace.enableNushellIntegration = true;
    direnv.enableNushellIntegration = true;
    eza.enableNushellIntegration = false;
  };
  home.sessionVariables.SHELL = "${pkgs.nushell}/bin/nu"; # Make it the default
}
