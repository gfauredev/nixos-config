{ ... }: {
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    installVimSyntax = true;
  };

  # See: https://ghostty.org/docs/config
  programs.ghostty.settings = {
    theme = "catppuccin-mocha";
    font-size = 12;
    # keybind = [ "ctrl+h=goto_split:left" "ctrl+l=goto_split:right" ];
  };

  # programs.ghostty.themes = { }; # TODO
}
