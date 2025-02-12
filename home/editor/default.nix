{ pkgs, ... }: { # CLI and GUI text editors
  imports = [ ./helix ./neovim ];

  home.packages = with pkgs; [
    tree-sitter-grammars.tree-sitter-typst
    # tabby # Self-hosted AI code assistant TODO configure
    # tabby-agent # LSP agent for Tabby TODO configure
    helix-gpt # Add LLMs support through LSP
  ];

  # TODO factorize extra packages (LPSs…)
}
