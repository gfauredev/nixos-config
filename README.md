---
lang: en
---

# My NixOS flake systems and homes configurations

## NixOS’ installation instructions

### _0._ Build the installer image

Build a custom image with the
[official method](https://nixos.org/manual/nixos/unstable/#sec-building-image),
or directly from this flake with
`nix build .#nixosConfigurations.installer.config.system.build.isoImage`.

Boot it from a bootable USB stick (preferably a multi-ISO one like with Ventoy).

Once booted, get this git repo with the command `clone` (or `clone-ssh` if
private key is availiable).

### _1._ Partition, encrypt, format disks (according to partitioning/ templates)

Use a tool like `fdisk` or `cfdisk` to partition and label disks :

- `fdisk /dev/???` (interactive)

If the choosen file system doesn’t support its own encryption, use
`cryptsetup …` to create an encrypted partition and mount it (for the root).

Then, format the partitions :

- `mkfs.fat -F 32 /dev/???? -n ESP` to host `/boot`
- `mkfs.??? /dev/????` to host `/` (the system root)

Finaly, depending on the choosen(s) filesystem(s), continue formating or
creating and mounting **subvolumes** with appropriate commands.

### _2._ Handle hardware configuration

Run the command `nixos-generate-config --root /mnt --dir .` to create a hardware
config in this directory.

Then, compare with choosen system hardware configuration and fix it if needed.

PS : UUIDs can be got with `lsblk -o NAME,SIZE,UUID,LABEL`.

### _3._ Install from the Nix flake

Use the command `nixos-install -v --root /mnt --flake '<path-to-flake>#HOST'` to
install the HOST specific NixOS system from this flake.

Then user homes can be installed with
`home-manager switch --flake <path-to-flake>#USER`, and the system can be
updated with `sudo nixos-rebuild --flake <path-to-flake>#HOSTNAME switch`.

### Develop !

A dev environment for a specific tech stack can be initialised with
`nix flake init --template templates#STACK` and then activated with
`nix develop`.

## Other configuration repositories

Some other git repositories constitute configuration elements, but are not
directly included in this flake:

- My personal [Typst library](https://gitlab.com/gfauredev/typst-lib)
  - Cloned at `$XDG_DATA_HOME/typst/packages/local`
