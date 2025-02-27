{ ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    enableCompletion = true;
    initExtra = builtins.readFile ./zshrc.sh; # TODO this cleaner
    sessionVariables.SHELL = "$(which zsh)"; # Set interactive shell
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignorePatterns = [ ];
      ignoreSpace = true;
      path = "$XDG_DATA_HOME/zsh_history";
      size = 30000;
      share = true;
    };
    historySubstringSearch.enable = true;
  };
}
