---
lang: en
---

# My NixOS Flake systems and homes configurations

## Conventions of this repository

- Files and directories names are `camelCase` and singular.
- `system` contains configurations related to specific devices (hosts).
  - Systems are generally named after a mythological entity.
  - The `module` subdirectory contains Nix modules
- `home` contains configuratons related to users homes.
  - Users usernames are generally their initials.
  - The `module` subdirectory contains Nix modules
- `template` contains dev environment flakes templates

## NixOS’ setup instructions

### _0._ Build the installer image

Build a custom image with the
[official method](https://nixos.org/manual/nixos/unstable/#sec-building-image),
or directly from this flake with
`nix build .#nixosConfigurations.installer.config.system.build.isoImage`.

Boot it from a bootable USB stick (preferably a multi-ISO one like with Ventoy).

Once booted, get this git repo with the command `clone` (or `clone-ssh` if
private key is availiable) that is built in the installer image.

### _1._ Partition, encrypt, format disks (according to partitioning/ templates)

Use a tool like `fdisk` or `cfdisk` to partition and label disks :

- `fdisk /dev/…` (interactive)

If the choosen file system doesn’t support its own encryption, use
`cryptsetup …` to create an encrypted partition and mount it (for the root).

Then, format the partitions :

- `mkfs.fat -F 32 /dev/… -n ESP` to host `/boot`
- `mkfs.??? /dev/…` to host `/` (the system root)

Finaly, depending on the choosen(s) filesystem(s), continue formating or
creating and mounting eventual **subvolumes** with appropriate commands.

### _2._ Handle hardware configuration

Run the command `nixos-generate-config --root /mnt --dir .` to create a hardware
config in this directory.

Then, compare with choosen system hardware configuration and fix it if needed.

Partitions UUIDs can be obtained with `lsblk -o NAME,SIZE,UUID,LABEL`.

### _3._ Install from the Nix flake

Use the command `nixos-install -v --root /mnt --flake '<path-to-flake>#$HOST'`
to install the `$HOST` specific NixOS system from this flake.

Then user home(s) can be installed with
`home-manager switch --flake <path-to-flake>#$HOST@$USER`, and the system can be
updated with `sudo nixos-rebuild --flake <path-to-flake> switch`, or better,
with my custom helper tool located at `home/shell/configure.sh` and mapped to
the command `cfg` (`cfg h` to display usage).

## Documentation and learning ressources

- [NixOS documentation](https://nixos.org/manual/nixos/unstable)
- [Home Manager documentation](https://nix-community.github.io/home-manager)
- [Home Manager options](https://nix-community.github.io/home-manager/options.html)
- [The Nix Way Dev Templates](https://github.com/the-nix-way/dev-templates)
- [NixOS Wiki](https://nixos.wiki)
- [nix.dev](https://nix.dev)
- [Vimjoyer YouTube channel](https://www.youtube.com/@vimjoyer)
- [Global Nix options search engine](https://searchix.alanpearce.eu/all/search)
- `manix` CLI Nix options search engine
- [NixOS starter flake configs](https://github.com/Misterio77/nix-starter-configs)
- [hlissner’s config](https://github.com/hlissner/dotfiles)
- [gvolpe’s config](https://github.com/gvolpe/nix-config/blob/master/flake.nix)
- [gvolpe’s private flake article](https://gvolpe.com/blog/private-flake)
- [yelite’s conf ex.](https://github.com/yelite/private-flake-example/blob/main/flake.nix)
- [yelite’s cfg article](https://greenfield.blog/posts/private-nix-flake-with-public-subtree)
- [mitchellh’s config](https://github.com/mitchellh/nixos-config)

## Other configuration repositories

Some other git repositories constitute configuration elements, but are not
directly included in this flake:

- My personal [Typst library](https://gitlab.com/gfauredev/typst-lib)
  - Cloned at `$XDG_DATA_HOME/typst/packages/local`
