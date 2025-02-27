{ ... }: {
  programs = {
    rofi = {
      enable = true;
      cycle = true;
      terminal = let
        term = # TODO this cleaner, factorize (duplicate of ../../shell/default.nix)
          {
            name = "ghostty"; # Name of the terminal (for matching)
            cmd = "ghostty"; # Launch terminal
            # cmd = "wezterm start --always-new-process"; # FIX when too much terms crash
            exec = ""; # Option to execute a command in place of shell
            cd = "--cwd"; # Option to launch terminal in a directory
            # Classed terminals (executes a command)
            monitoring = "wezterm start --class monitoring"; # Monitoring
            note = "wezterm start --class note"; # Note
            menu =
              "wezterm --config window_background_opacity=0.7 start --class menu"; # Menu
          };
      in "${term.cmd} ${term.exec}";
      font = "FiraCode Nerd Font";
      theme = ./rounded-blue-dark.rasi;
      # plugins = with pkgs; [ rofi-emoji-wayland ];
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
