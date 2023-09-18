# Libs & Programming languages
with import <nixpkgs> { };
let
  packages = [
    sqlcl # Oracle DB CLI
    sqlite-web
    # sqls # Language server
  ];
in
pkgs.mkShell
{
  name = "SQL";
  buildInputs = with pkgs; (packages);
  shellHook = "exec zsh";
}
