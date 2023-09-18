---
lang: en
---

# My NixOS flake-based systems and homes configurations

## NixOS installation instructions

### *0.* Build the installer image

Run `nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=installer.nix`
to build the installer ISO image.

Place it in a bootable USB stick, for example made with Ventoy, then boot it
on the machine on which to install NixOS.

Once booted, get this git repo with the command `clone`.

### *1.* Partition, encrypt, format disks (according to partitioning/ templates)

Use the tools `fdisk` or `cfdisk` to partition and label disks properly.

Then use `cryptsetup …` to encrypt the root partition if the choosen
filesystem doesn’t support its own encryption.

Then use `mkfs.fat -F 32 /dev/???` to format `/boot` and `mkfs.??? /dev/???` to
format `/` (the root).

Finaly, depending on the choosen(s) filesystem(s), continue formating with
`mkfs.??? /etc/???` or create proper **subvolumes** with filesystem specific
commands.

### *2.* Handle hardware configuration

Run the command `nixos-generate-config --root /mnt --dir .` to create a hardware
config in this directory.

Then, compare with choosen system hardware configuration and fix it if needed.

PS : UUIDs can be got with `lsblk -o NAME,SIZE,UUID,LABEL`.

### *3.* Install from the Nix Flake

Use the command `nixos-install -v --root /mnt --flake '.#HOSTNAME'` to install
NixOS from this flake (according you run this command from the same directory
as this current file).

Then to update the system run `sudo nixos-rebuild --flake '.#HOSTNAME' switch`.

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

- [ ] Add useful things from old config to dev shells
- [ ] Study & configure Musnix & realtime audio & audio improvements
- [ ] Study & configure Nixos-hardware & hardware improvements
- [ ] Power consumption improvements
- [ ] Try to use `pkgs.runCommand` to create config links
  - [ ] `~/dl` → `/run/user/$UID/dl` (needs a mkdir)
  - [ ] `~/usb` → `/run/media/$USER` (needs a mkdir)
- [ ] Use `pkgs.runCommand` to run config commands
- [ ] Execute `# echo GPP0 > /proc/acpi/wakeup` on `knight`’s boot to fix suspend
- [ ] Eventually `git pull --recurse-submodules --jobs=8` on this directory & password store at boot to update
- [ ] FIX `ninja`’s fingerprint reader
- [ ] Synchronize `.config/libreoffice/4/user/template/$USER` contents (eventually with syncthing)
- [ ] Test if zoxide works correctly
- [ ] Port ruff config in dev shell

## Optional packages

> These are packages I don’t want in my config but will eventually \
> install with `nix-env -iA nixos.$PACKAGE` or `nix-env -iA nixpkgs.$PACKAGE`

- `chntpw` Edit an installed Windows registry
- `veracrypt` Multiplatform encryption

## Non-redistributable packages

> These are packages that require downloading assets from various places \
> and add them to the Nix store with `$ nix-store --add-fixed sha256 /path/to/file` \
> before being installed with `nix-env -iA nixos.$PACKAGE` or `nix-env -iA nixpkgs.$PACKAGE`

- `ciscoPacketTracer8` # Advanced network simulation
- `sqldeveloper` # Oracle SQL IDE
- `sqlcl` # Oracle SQL CLI
- `burpsuite` # Pentesting suite
