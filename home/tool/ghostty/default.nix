{ ... }: {
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    installVimSyntax = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # programs.ghostty.settings = { }; # TODO

  # programs.ghostty.themes = { }; # TODO
}
