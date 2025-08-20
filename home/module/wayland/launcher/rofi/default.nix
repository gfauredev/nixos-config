{ config, ... }:
{
  programs = {
    rofi = {
      enable = true;
      cycle = true;
      terminal = "${config.term.cmd} ${config.term.exec}";
      pass = {
        enable = true;
        extraConfig = "";
        stores = [ "$XDG_DATA_HOME/password-store/" ];
      };
      extraConfig = {
        modes = "combi,window,drun";
        combi-modes = "window,drun";
        sorting-method = "fzf";
        show-icons = true;
      };
    };
  };
}
