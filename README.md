---
lang: en
---

# My NixOS flake systems and homes configurations

## NixOS installation instructions

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
- My Vital(ium) [presets collection](https://gitlab.com/gfauredev/vital)
  - Cloned at `$XDG_DATA_HOME/Vital`
  - Symlinkedd at `$XDG_DATA_HOME/Vitalium`

## Documentation ressources :

- [NixOS documentation](https://nixos.org/manual/nixos/unstable)
- [Home Manager documentation](https://nix-community.github.io/home-manager)
- [Every Home Manager options](https://nix-community.github.io/home-manager/options.html)
- [NixOS Wiki](https://nixos.wiki)
- [nix.dev](https://nix.dev)
- [Vimjoyer YouTube channel](https://www.youtube.com/watch?v=bjTxiFLSNFA&list=PLko9chwSoP-15ZtZxu64k_CuTzXrFpxPE)
- [NixOS starter flake configs](https://github.com/Misterio77/nix-starter-configs)
- [hlissner dotfiles](https://github.com/hlissner/dotfiles)
- `manix` CLI tool

## TODO

> Consider TODO, FIXME, TEST and WARNING tags already inside files

- [ ] Improve installer ISO creation (installer in `flake.nix` NixOS
      configurations)
  - Consider using nixos-generators like
    `nixos-generate -f iso -c installer.nix`
- [ ] Improve rofi menu (frecency sorting, fuzzy matching …) or test other menus
      with more features

## Optional packages

> These are packages I don’t want in my config but will eventually use
> ephemerally with `nix-shell -p $PACKAGE` or install with
> `nix-env -iA nixos.$PACKAGE` or `nix-env -iA nixpkgs.$PACKAGE`

- `veracrypt` # Multiplatform encryption
- `chntpw` # Edit an installed Windows registry
- `gns3-gui` # Advanced network simulation
- `gns3-server` # Advanced network simulation (server)

## Optional flakes

> These are packages I don’t want in my config but will eventually install with
> `nix profile install URL`

- `github:Wazzaps/fingerpaint` # Use touchpad to draw

## Non-redistributable packages

> These are packages that require downloading assets from various places and add
> them to the Nix store with `$ nix-store --add-fixed sha256 /path/to/file`
> before being ephemerally used with `nix-shell -p $PACKAGE` or being installed
> with `nix-env -iA nixos.$PACKAGE` or `nix-env -iA nixpkgs.$PACKAGE`

- `protonvpn-gui` # Partly free VPN
- `ciscoPacketTracer8` # Network simulation
- `sqldeveloper` # Oracle SQL IDE
- `sqlcl` # Oracle SQL CLI
- `burpsuite` # Pentesting suite
- `minecraft` # Mythic sandbox game
  - `fabric-installer` # Minecraft modding toolchain
