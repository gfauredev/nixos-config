---
lang: en
---

# My NixOS flake-based systems and homes configurations

## NixOS installation instructions

If you read this, you’ve already done the first step which is 
downloading this config.

### *1.* Partition, (encrypt), format disks according to hardware-config templates

Use the tools `fdisk` or `cfdisk` to partition and label disks properly.

Then use `cryptsetup ???` to encrypt the root partition.

Then use `mkfs.fat -F 32 /dev/???` to format `/boot` and `mkfs.btrfs /dev/???`
(or `mkfs.bcachefs /dev/???`) to format `/` (the root).

Finaly create proper subvolumes with commands `btrfs ???`.

### *2.* Create `/mnt/etc/nixos/hardware-config.nix` from template with real UUIDs

Create directory `/mnt/etc/nixos/` and copy proper template to it as
`hardware-config.nix`.

Then fill in the template with actual UUIDs got with
`lsblk -o NAME,SIZE,UUID,LABEL`.

### *3.* Install from the Nix Flake

Use the command `nix ???`.

## Documentation ressources :

- [NixOS documentation](https://nixos.org/manual/nixos/stable/#sec-building-image)
- [Home manager documentation](https://nix-community.github.io/home-manager/index.html#ch-nix-flakes)
- [NixOS Wiki](https://nixos.wiki/wiki/Flakes)
- [NixOS starter flake configs](https://github.com/Misterio77/nix-starter-configs/tree/main)
- [Vimjoyer youtube channel](https://www.youtube.com/watch?v=bjTxiFLSNFA&list=PLko9chwSoP-15ZtZxu64k_CuTzXrFpxPE)
- [hlissner dotfiles](https://github.com/hlissner/dotfiles)
- [nix.dev](https://nix.dev)

## TODO

> Consider TODO, FIXME, TEST and WARNING tags already inside files

- [ ] Add useful things from old config to dev shells
- [ ] Study & configure Musnix & realtime audio & audio improvements
- [ ] Study & configure Nixos-hardware & hardware improvements
- [ ] Power consumption improvements

## Optional packages

> These are packages I don’t want in my config but will eventually \
> install with `nix-env -iA nixpkgs.$PACKAGE`

## Non-redistributable packages

> These are packages that require downloading assets from various places \
> and add them to the Nix store with `nix ???` \
> before being installed with `nix-env -iA nixpkgs.$PACKAGE`

- `ciscoPacketTracer8` # Advanced network simulation
- `sqldeveloper` # Oracle SQL IDE
- `sqlcl` # Oracle SQL CLI
