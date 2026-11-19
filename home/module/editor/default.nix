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
    ./zed
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
        # Natural Language
        harper # Grammar/spell checker LSP (Rust, fast)
        ltex-ls-plus # Text grammar checker LSP using Languagetool (Java, slow)
        # markdown-oxide # PKM (links, tags, dates…)
        marksman # Wikilinks, ToC generation…
        # vale-ls # LSP Vale implementation
        # Language Servers & Linters
        bash-language-server # Bash, shell script LSP
        # lorri # Your project's nix-env, to test
        pkgs-unstable.nixd # "Official" Nix LSP
        pkgs-unstable.nil # Nix LSP
        nurl # Get FOD’s hashes without rebuilding everything
        nix-update # Auto update flakes, FODs hashes…
        nufmt # Nushell formatter
        pkgs-unstable.nixfmt # Formatter
        pkgs-unstable.nixfmt-tree # Format a whole directory of nix files
        openscad-lsp # Code based 3D CAD LSP
        rust-analyzer # Globally for rust-script
        shellcheck # Shell script analysis
        shfmt # Shell script formatter
        taplo # TOML LSP
        tinymist # Typst LSP
        typstyle # Typst formatter
        vscode-langservers-extracted # HTML/CSS/JS(ON)
        yaml-language-server # YAML LSP
      ];
      description = ''
        Packages available to all the text editors, everywhere on the system
      '';
    };
  };
}
