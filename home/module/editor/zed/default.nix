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
  };

  xdg.configFile."zed/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/editor/zed/settings.json";
}
