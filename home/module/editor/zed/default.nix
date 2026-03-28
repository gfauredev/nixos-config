{ config, pkgs-unstable, ... }:
{
  programs.zed-editor.enable = true;

  programs.zed-editor = {
    package = pkgs-unstable.zed-editor;
    # defaultEditor = true;
    extraPackages = config.editor.commonPackages;
    extensions = [
      # "bash"
      # "biome-zed"
      "dockerfile"
      "emmet"
      "harper"
      # "haskell"
      "html" # "zed/extensions/html"
      # "html-jinja"
      # "html-snippets"
      # "htmx-lsp"
      # "http"
      # "hyprlang"
      "java"
      # "java-eclipse-jdtls"
      # "javascript-snippets"
      # "jj-lsp"
      # "jq"
      # "json5"
      # "jsonl"
      # "just"
      "kotlin"
      # "ltex"
      "lua"
      "make"
      # "neocmake"
      # "nginx"
      # "nickel"
      "nix"
      "nu"
      # "nu-lint"
      # "racket"
      # "rust-snippets"
      # "scheme"
      "sql"
      # "scss"
      "toml"
      # "typescript-snippets"
      # "typos"
      "typst"
      # "zig"
    ];
    installRemoteServer = true;
  };
}
