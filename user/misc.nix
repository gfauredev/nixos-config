{ inputs, lib, config, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      # TODO refile them properly
      # sqldeveloper # PROPRIETARY SQL Oracle IDE
      # sqlcl # Oracle DB CLI
      # insomnia # REST client
      # dbeaver # Database (SQL) analyzer
      # gns3-gui # Network simulator
      # umlet
      # android-studio
      # usbimager
      # blueman
      # nodePackages.browser-sync # Live website preview, use apache instead
    ];

    programs = {
      # autorandr = { # TEST relevance
      #   enable = true;
      # };
      # eww = {
      #   enable = true;
      #   configDir = ../eww;
      # };
      # eclipse = {
      #   enable = true;
      # };
      # java.enable = true; # TODO replace with dev shell
    };

    services = {
      # kanshi = {
      #   enable = true;
      #   profiles = {};
      # };
      # picom = {
      #   enable = true;
      # };
    };
  };
}
