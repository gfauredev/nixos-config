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
    ./neovim
    # ./zed
  ];

  options.editor = with lib; {
    desktop = mkOption {
      type = types.str;
      default = "Helix";
      description = "Main text editor desktop entry name (without .desktop)";
    };

    commonPackages = lib.mkOption {
      default = with pkgs; [
        (tree-sitter.withPlugins (p: builtins.attrValues p)) # Every grammar
        deno # Runtime for LSPs and formatters
        # Language Models
        helix-gpt # Add LLMs support through LSP
        copilot-language-server # GitHub Copilot LSP
        # lsp-ai # Language server for language models
        # tabby # Self-hosted AI code assistant
        # Spell Checking
        harper # Grammar/spell checker LSP (Rust, fast)
        # hunspell # Classic spell checker
        # hunspellDicts.fr-any # French
        # hunspellDicts.en_US # American
        # hunspellDicts.en_GB-ise # British
        # hunspellDicts.es_ES # Spanish
        ltex-ls-plus # Text grammar checker LSP using Languagetool (Java, slow)
        # vale # Linter for prose
        # vale-ls # LSP Vale implementation
        # Language Servers & Linters
        bash-language-server # Bash, shell script LSP
        # lorri # Your project's nix-env, to test
        marksman # Wikilinks, ToC generation…
        # markdown-oxide # PKM (links, tags, dates…)
        pkgs-unstable.nixd # "Official" Nix LSP
        pkgs-unstable.nil # Nix LSP
        # niv # Easy dependency management, to test
        pkgs-unstable.nixfmt # Formatter
        pkgs-unstable.nixfmt-tree # Format a whole directory of nix files
        # nls # Nickel LSP
        # pkgs-unstable.rumdl # Fast markdown linter & formatter
        rust-analyzer # Globally for rust-script
        # statix # Lints & suggestions for Nix, to test
        sbctl # SecureBoot key manager, used for install with Lanzaboote
        shellcheck # Shell script analysis
        taplo # TOML LSP
        tinymist # Typst LSP
        typstyle # Typst formatter
        # vscode-langservers-extracted # HTML/CSS/JS(ON)
        yaml-language-server # YAML LSP
      ];
      description = ''
        Packages available to all the text editors, everywhere on the system
      '';
    };
  };

  config.home.file.".dprint.jsonc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/editor/dprint.jsonc";
}
