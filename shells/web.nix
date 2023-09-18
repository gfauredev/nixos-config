# web-shell.nix
with import <nixpkgs> { };
let
  packages = [
    bun # even better JS runtime
    # deno # better JS runtime
    nodejs # JS runtime

    nodePackages_latest.npm # package manager
    nodePackages_latest.pnpm # better package manager

    nodePackages_latest.typescript # typescript compiler

    php
    php82Packages.composer

    nodePackages_latest.vscode-langservers-extracted # web
    nodePackages_latest.typescript-language-server # typescript
    nodePackages_latest.vue-language-server # vue language server
    nodePackages_latest.intelephense # PHP language server
    sqls # SQL Language server

    nodePackages_latest.html-minifier
    nodePackages_latest.prettier
  ];
in
pkgs.mkShell
{
  name = "web";
  allowUnfree = true;
  buildInputs = with pkgs; (packages);
  shellHook = "exec zsh";
}
