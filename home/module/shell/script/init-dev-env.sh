# TODO make templates repo a Nix option
nix flake init -t "github:gfauredev/dev-templates#$1"
direnv allow
