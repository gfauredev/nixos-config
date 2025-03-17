{ pkgs, ... }:
let
  editor-packages = with pkgs; [
    (tree-sitter.withPlugins (p: builtins.attrValues p)) # Every grammar
    # tabby # Self-hosted AI code assistant TODO configure
    # tabby-agent # LSP agent for Tabby TODO configure
    # lsp-ai # Language server for language models
    helix-gpt # Add LLMs support through LSP

    harper # Grammar and spell checker for text, documentation, and comments
    # vale # Linter for prose
    # vale-ls # LSP Vale implementation
    # languagetool # Advanced spell checking (Java, slow)
    ltex-ls-plus # Text grammar checker LSP using Languagetool (Java, slow)
    # hunspell # Standard spell checker
    # hunspellDicts.fr-any # French
    # hunspellDicts.en_US # American
    # hunspellDicts.en_GB-ise # British
    # hunspellDicts.es_ES # Spanish

    dprint # Pluggable code formatting platform
    # nil # Nix LSP
    # nixfmt # Nix formater
    # nls # Nickel LSP
    # yaml-language-server # YAML LSP
    # taplo # TOML LSP

    # bash-language-server # Bash, shell script LSP
    # shellcheck # Shell script analysis
    # shfmt # Shell script formater

    # vscode-langservers-extracted # HTML/CSS/JS(ON)

    marksman # Smart Markdown links
    # markdown-oxide # TEST Obsidian style PKM
  ];
in { # CLI and GUI text editors
  imports = [ ./helix ./neovim ]; # ./zed ];

  programs.helix.extraPackages = editor-packages;
  programs.neovim.extraPackages = editor-packages;

  # TODO cleaner common editor packages with nix modules
}
