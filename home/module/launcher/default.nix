{ pkgs, term, ... }: {
  home.packages = with pkgs;
    [
      libqalculate # Calculation library used by rofi
      # albert # Full-featured launcher
    ];

  programs = {
    rofi = {
      enable = true;
      cycle = true;
      terminal = "${term.cmd} ${term.exec}";
      font = "FiraCode Nerd Font";
      theme = ./rounded-blue-dark.rasi;
      # plugins = with pkgs; [ rofi-calc rofi-emoji ]; # TODO reenable
      pass = {
        enable = true;
        extraConfig = "";
        stores = [ "$HOME/.password-store/" ];
      };
      extraConfig = {
        modes = "combi,drun,window,ssh";#,calc,emoji";
        combi-modes = "window,drun,ssh";#,emoji";
        sorting-method = "fuzzy";
        show-icons = true;
      };
    };
  };
}
