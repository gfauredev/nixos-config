{ ... }:
{
  programs.zsh.enable = true;
  programs.zsh = {
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    enableCompletion = true;
    initContent = builtins.readFile ./zshrc.sh;
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
  services.gpg-agent.enableZshIntegration = true;
  programs = {
    starship.enableZshIntegration = true;
    zoxide.enableZshIntegration = true;
    broot.enableZshIntegration = true;
    direnv.enableZshIntegration = true;
    eza.enableZshIntegration = true;
  };
}
