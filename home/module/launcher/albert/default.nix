{ pkgs-unstable, config, ... }:
{
  home.packages = [ pkgs-unstable.albert ]; # Full-featured launcher

  xdg.configFile = {
    "albert/config.link" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/albert/config";
    };
    "albert/websearch.link" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/albert/websearch";
    };
  };

  systemd.user.services.albert = {
    Unit.Description = "Albert Launcher";
    Unit.PartOf = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs-unstable.albert}/bin/albert";
      Restart = "on-failure";
    };
  };
}
