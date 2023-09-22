---
lang: en
---

# My NixOS flake-based systems and homes configurations

## NixOS installation instructions

### _0._ Build the installer image

Build a custom image with the [official method](https://nixos.org/manual/nixos/unstable/#sec-building-image). \
(More convenient `nixos-generate -f iso -c installer.nix` might also work)

Place it in a bootable USB stick, for example made with Ventoy, then boot it
on the machine on which to install NixOS.

Once booted, get this git repo with the command `clone`.

### _1._ Partition, encrypt, format disks (according to partitioning/ templates)

Use the tools `fdisk` or `cfdisk` to partition and label disks properly.

Then use `cryptsetup …` to encrypt the root partition if the choosen
filesystem doesn’t support its own encryption.

Then use `mkfs.fat -F 32 /dev/???` to format `/boot` and `mkfs.??? /dev/???` to
format `/` (the root).

Finaly, depending on the choosen(s) filesystem(s), continue formating with
`mkfs.??? /etc/???` or create proper **subvolumes** with filesystem specific
commands.

### _2._ Handle hardware configuration

Run the command `nixos-generate-config --root /mnt --dir .` to create a hardware
config in this directory.

Then, compare with choosen system hardware configuration and fix it if needed.

PS : UUIDs can be got with `lsblk -o NAME,SIZE,UUID,LABEL`.

### _3._ Install from the Nix Flake

Use the command `nixos-install -v --root /mnt --flake '.#HOSTNAME'` to install
NixOS from this flake (according you run this command from the same directory
as this current file).

Then user homes can be installed with `home-manager switch --flake .#USER`,
and the system can be updated with `sudo nixos-rebuild --flake .#HOSTNAME switch`.

### Develop !

A dev environment can be initialised with `nix flake init --template templates#TECHNO`

## Documentation ressources :

- [NixOS documentation](https://nixos.org/manual/nixos/stable/#sec-building-image)
- [Home manager documentation](https://nix-community.github.io/home-manager/index.html#ch-nix-flakes)
- [Every home manager options](https://nix-community.github.io/home-manager/options.html)
- [NixOS Wiki](https://nixos.wiki/wiki/Flakes)
- [Nix Cookbook](https://nixos.wiki/wiki/Nix_Cookbook)
- [NixOS starter flake configs](https://github.com/Misterio77/nix-starter-configs/tree/main)
- [Vimjoyer youtube channel](https://www.youtube.com/watch?v=bjTxiFLSNFA&list=PLko9chwSoP-15ZtZxu64k_CuTzXrFpxPE)
- [hlissner dotfiles](https://github.com/hlissner/dotfiles)
- [nix.dev](https://nix.dev)

## TODO

> Consider TODO, FIXME, TEST and WARNING tags already inside files

- [ ] Installer ISO creation in flake.nix
- [ ] Study & configure Musnix & realtime audio & audio improvements
- [ ] hardware & Power consumption improvements
- [ ] FIX `ninja`’s fingerprint reader
- [ ] `pkgs.runCommand` or another nix-way to run config commands
  - [ ] Execute `# echo GPP0 > /proc/acpi/wakeup` on `knight`’s boot to fix suspend
- [ ] Eventually `git pull --recurse-submodules --jobs=8` on this directory & password store at boot to update
- [ ] Synchronize `.config/libreoffice/4/user/template/$USER` contents (eventually with syncthing)
- [ ] Improve rofi menu (estethics, fuzzy, frecency …)

## Optional packages

> These are packages I don’t want in my config but will eventually \
> use ephemarally with `nix-shell -p $PACKAGE` or \
> install with `nix-env -iA nixos.$PACKAGE` or `nix-env -iA nixpkgs.$PACKAGE`

- `chntpw` # Edit an installed Windows registry
- `veracrypt` # Multiplatform encryption

## Non-redistributable packages

> These are packages that require downloading assets from various places \
> and add them to the Nix store with `$ nix-store --add-fixed sha256 /path/to/file` \
> before being ephemarally used with `nix-shell -p $PACKAGE` or \
> being installed with `nix-env -iA nixos.$PACKAGE` or `nix-env -iA nixpkgs.$PACKAGE`

- `ciscoPacketTracer8` # Advanced network simulation
- `sqldeveloper` # Oracle SQL IDE
- `sqlcl` # Oracle SQL CLI
- `burpsuite` # Pentesting suite
