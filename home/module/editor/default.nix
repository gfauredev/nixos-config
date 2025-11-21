{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}: # CLI and GUI text editors
{
  imports = [
    ./helix
    # ./zed
    ./neovim
  ];

  options.editor.commonPackages = lib.mkOption {
    default = with pkgs; [
      (tree-sitter.withPlugins (p: builtins.attrValues p)) # Every grammar
      # Language Models
      # tabby # Self-hosted AI code assistant TODO configure
      # tabby-agent # LSP agent for Tabby TODO configure
      # lsp-ai # Language server for language models
      helix-gpt # Add LLMs support through LSP
      deno # Runtime for LSPs and formatters
      # Spell Checking
      harper # Grammar/spell checker LSP (Rust, fast)
      # vale # Linter for prose
      # vale-ls # LSP Vale implementation
      ltex-ls-plus # Text grammar checker LSP using Languagetool (Java, slow)
      # languagetool # Advanced spell checking (Java, slow)
      # hunspell # Classic spell checker
      # hunspellDicts.fr-any # French
      # hunspellDicts.en_US # American
      # hunspellDicts.en_GB-ise # British
      # hunspellDicts.es_ES # Spanish
      # Language Servers & Linters
      pkgs-unstable.nixd # "Official" Nix LSP
      pkgs-unstable.nixfmt # Formatter
      tinymist # Typst LSP
      typstyle # Typst formatter
      marksman # Wikilinks, ToC generation…
      # markdown-oxide # PKM (links, tags, dates…)
      # pkgs-unstable.rumdl # Fast markdown linter & formatter
      # nls # Nickel LSP
      # yaml-language-server # YAML LSP
      # taplo # TOML LSP
      # bash-language-server # Bash, shell script LSP
      # shellcheck # Shell script analysis
      # sqruff # SQL linter
      # sqls # SQL language server
      # vscode-langservers-extracted # HTML/CSS/JS(ON)
      # Formatters
      # dprint # Pluggable code formatting platform
      # shfmt # Shell script formater # Bash LSP instead
      # sql-formatter # SQL formatter
    ];
    description = ''
      Packages available to all the text editors, everywhere on the system
    '';
  };

  config.home.file.".dprint.jsonc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/editor/dprint.jsonc";

  config.eclipse = {
    enable = true;
    package = pkgs.eclipses.eclipse-embedcpp;
  };
}
