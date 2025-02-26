{ pkgs, stablepkgs, ... }:
let
  editor-packages = with pkgs; [
    (tree-sitter.withPlugins (_: allGrammars)) # All Tree-Sitter grammars
    # (pkgs.tree-sitter.withPlugins # Select Tree-Sitter grammars
    #   (p: [ p.tree-sitter-c p.tree-sitter-typescript ]))
    dprint # Pluggable code formatting platform

    # tabby # Self-hosted AI code assistant TODO configure
    # tabby-agent # LSP agent for Tabby TODO configure
    # lsp-ai # Language server for language models
    helix-gpt # Add LLMs support through LSP

    harper # Grammar and spell checker for text, documentation and comments
    # vale # Linter for prose
    # vale-ls # LSP Vale implementation
    # languagetool # Advanced spell checking (Java, slow)
    ltex-ls-plus # Text grammar checker LSP using Languagetool (Java, slow)
    # hunspell # Standard spell checker
    # hunspellDicts.fr-any # French
    # hunspellDicts.en_US # American
    # hunspellDicts.en_GB-ise # British
    # hunspellDicts.es_ES # Spanish

    nil # Nix
    nixfmt # Formatter
    nls # Nickel
    yaml-language-server # YAML
    taplo # TOML

    bash-language-server # Bash, shell script
    shellcheck # Analysis
    shfmt # Formatter
    stablepkgs.explain # Explain system call errors

    tinymist # Typst
    typstyle # Typst formatter
    # markdown-oxide # TEST Obsidian style PKM
    marksman # Smart Markdown links

    lua-language-server # Lua
    vscode-langservers-extracted # HTML/CSS/JSON
  ];
in { # CLI and GUI text editors
  imports = [ ./helix ./neovim ]; # ./zed ];

  programs.helix.extraPackages = editor-packages;

  programs.neovim.extraPackages = editor-packages;

  # TODO cleaner common editor packages with nix modules
}
