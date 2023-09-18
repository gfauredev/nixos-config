# Libs & Programming languages
with import <nixpkgs> { };
let
  packages = [
    jdk
    gradle
    java-language-server
    # javaPackages.junit_4_12
  ];
in
pkgs.mkShell
{
  name = "java";
  buildInputs = with pkgs; (packages);
  shellHook = "exec zsh";
}
