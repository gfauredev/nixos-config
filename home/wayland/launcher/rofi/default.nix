{ pkgs, term, ... }: {
  programs = {
    rofi = {
      enable = true;
      cycle = true;
      terminal = "${term.cmd} ${term.exec}";
      font = "FiraCode Nerd Font";
      theme = ./rounded-blue-dark.rasi;
      plugins = with pkgs; [ rofi-emoji-wayland ];
      pass = {
        enable = true;
        extraConfig = "";
        stores = [ "$XDG_DATA_HOME/password-store/" ];
      };
      extraConfig = {
        modes = "combi,drun,window,ssh,emoji";
        combi-modes = "window,drun,ssh,emoji";
        sorting-method = "fzf";
        show-icons = true;
      };
    };
  };
}
