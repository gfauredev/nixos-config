# TODO make templates repo URL a Nix option TODO consider prioritizing local dir
nix flake init -t "github:gfauredev/dev-templates#$1"
direnv allow
