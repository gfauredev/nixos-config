{ config, pkgs-unstable, ... }:
{
  programs.zed-editor.enable = true;

  programs.zed-editor = {
    package = pkgs-unstable.zed-editor;
    # defaultEditor = true;
    extraPackages = config.editor.commonPackages;
    installRemoteServer = true;
    mutableUserDebug = true;
    mutableUserKeymaps = true;
    mutableUserSettings = true;
    mutableUserTasks = true;
    extensions = [
      "astro"
      # "bash"
      "biome" # "biome-zed"
      "csv"
      "dockerfile"
      "emmet"
      "git-firefly"
      "graphql"
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
      "latex"
      # "ltex"
      "lua"
      "log"
      "make"
      "markdown-oxide"
      "neocmake"
      # "nginx"
      # "nickel"
      "nix"
      "nu"
      # "nu-lint"
      # "pylsp"
      # "racket"
      # "rust-snippets"
      # "scheme"
      "sql"
      "scss"
      "toml"
      # "typescript-snippets"
      # "typos"
      "typst"
      "xml"
      # "zig"
    ];
  };

  xdg.configFile."zed/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/editor/zed/settings.json";
}
