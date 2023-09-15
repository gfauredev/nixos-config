---
lang: en
---

# My NixOS flake-based systems and homes configurations

## NixOS installation instructions

If you read this, you’ve already done the first step which is 
downloading this config.

### Encrypt & format disks

### Install from the Nix Flake

## Documentation ressources :

- [Home manager documentation](https://nix-community.github.io/home-manager/index.html#ch-nix-flakes)
- [NixOS documentation](https://nixos.org/manual/nixos/stable/#sec-building-image)
- [NixOS starter flake configs](https://github.com/Misterio77/nix-starter-configs/tree/main)
- [NixOS Wiki](https://nixos.wiki/wiki/Flakes)
- [Vimjoyer youtube channel](https://www.youtube.com/watch?v=bjTxiFLSNFA&list=PLko9chwSoP-15ZtZxu64k_CuTzXrFpxPE)
- [hlissner dotfiles](https://github.com/hlissner/dotfiles)
- [nix.dev](https://nix.dev)

## TODO

> Consider TODO, FIXME, TEST and WARNING tags already inside files

- Study & configure Musnix & realtime audio & audio improvements
- Study & configure Nixos-hardware & hardware improvements
- Power consumption improvements

## Optional packages

> These are packages I don’t want in my config but will eventually
> install with `nix-env -iA nixpkgs.$PACKAGE`

## Non-redistributable packages

> These are packages that require downloading assets from various places
> and add them to the Nix store with `nix ???`
> before being installed with `nix-env -iA nixpkgs.$PACKAGE`

- `ciscoPacketTracer8` # Advanced network simulation
