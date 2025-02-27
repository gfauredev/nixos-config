{ ... }: {
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    installVimSyntax = true;
  };

  # See: https://ghostty.org/docs/config
  # programs.ghostty.settings = { }; # TODO

  # programs.ghostty.themes = { }; # TODO
}
