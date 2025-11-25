---
lang: en
---

# My NixOS Flake systems and homes configurations

<!--toc:start-->

- [My NixOS Flake systems and homes configurations](#my-nixos-flake-systems-and-homes-configurations)
  - [Conventions of this repository](#conventions-of-this-repository)
  - [NixOS’ setup instructions](#nixos-setup-instructions)
    - [_0._ Build the installer image](#0-build-the-installer-image)
    - [_1._ Partition, encrypt, format disks](#1-partition-encrypt-format-disks)
    - [_2._ Handle hardware configuration](#2-handle-hardware-configuration)
    - [_3._ Install from the Nix Flake](#3-install-from-the-nix-flake)
    - [_5._ Set up Secure Boot](#5-set-up-secure-boot)
  - [Other configuration repositories](#other-configuration-repositories)
  - [Documentation and learning ressources](#documentation-and-learning-ressources)

<!--toc:end-->

**NixOS** allows me to have a system perfectly tailored to my
needs and expectations. I’m highly demandant on ergonomics, so I use a lot of
tools that make interacting with the computer more efficient and comfortable.
Having to use the mouse is a chore, so I live mostly in the terminal and in
keyboard-driven apps. I also hate when choices are made for me, things like
default (bloat) software or common configuration, and **NixOS** allows me to
configure my system at the very level of detail I want.

First, I use the [bépo](https://bepo.fr) ergonomic **keyboard layout**, which is
optimized for writing French, as well as english and code. There are other
optimized layouts worth considering, such as [Ergopti](https://ergopti.fr) or
[Optimot](https://optimot.fr).

Added to that, the amazing [keyd](https://github.com/rvaiya/keyd) kernel-level
key remapping daemon, that allows me to define system-wide Vim-like motions and
chords.

[Hyprland](https://hyprland.org) dynamic wayland **window manager**, to
efficiently organize apps on monitors and workspace with the keyboard,
complemented with **Waybar** (also considering **Eww**).

Physically, my keyboard looks like…
[![Framework Laptop 13 keyboard](griffin-physical-keymap.png)](https://keyboard-layout-editor.com/#/gists/afaa8480eeb1b7cec95a0fbd7199ebd8)
…but this config has his bunch of remappings… TODO add keymaps with remaps.

[Nushell](https://www.nushell.sh) **interactive shell**, modern, working with
structured data, allowing sophisticated pipelines on them. I use it along a lot
of other tools that make terminal life easier.

- [starship](https://starship.rs) prompt to always know where you are and other
  useful status information using the shell.
- [broot](https://dystroy.org/broot) fast and ergonomic file fuzzy-finder.
- [zoxide](https://github.com/ajeetdsouza/zoxide) smater, faster cd alternative.
- [bat](https://github.com/sharkdp/bat) to display text files neatly.
- [atuin](https://atuin.sh) cross-terminal and cross-devices command history.
- [ripgrep](https://github.com/BurntSushi/ripgrep) with
  [ripgrep-all](https://github.com/phiresky/ripgrep-all) to quickly search
  full-text inside any file.
- [fd](https://github.com/sharkdp/fd) to quickly find files.
- [sd](https://github.com/chmln/sd) to easily replace a pattern in one or a
  batch of files.
- [bottom](https://github.com/ClementTsang/bottom) to monitor system ressources
  with neat plots.
- …

Aditionnally, I use [Dash shell](http://gondor.apana.org.au/~herbert/dash) as my
**login shell** and default scripts runner (`/bin/sh`), because it’s very fast,
stricly POSIX compliant and by such has a reduced attack surface.

[Helix](https://helix-editor.com) is my go-to **text editor** which is
terminal-based, featureful, modern and most importantly modal, allowing to edit
text very efficiently. It has strong LSP support, interesting productivity
features such as global pickers, and growing DAP and plugins support.

My main **terminal** emulator is [Ghostty](https://ghostty.org) which is modern,
quick and feature-complete, but I use [Alacritty](https://alacritty.org) as a
fallback, which is less featurefull, but robust.

[Albert](https://albertlauncher.github.io) is my general **launcher** with which
I launch apps, web searches, do calculations, quickly copy passwords, search for
emojies…

[Thunderbird](https://www.thunderbird.net) for **personal information
management**. Not exactly keyboard-driven, but very comprehensive and
standards-based. I’m considering CLI tools such as
[himalaya](https://github.com/pimalaya/himalaya) and
[khal](https://github.com/pimutils/khal).

[Stylix](https://stylix.danth.me) Flake to enforce my favorite color theme, my
favorite fonts and other style settings everywhere. To fully leverage OLED
screens for power saving, I always set background to pitch black `#000000`.

- [Catppuccin Mocha](https://catppuccin.com) colorscheme, with black background.
- [Libertinus Serif]() Serif font, for paragraphs…
- [Aileron]() Sans font, for titles, slides…
- [JetBrainsMono]() `Nerd Font` Mono font, for code, terminal…
- [Noto Color Emoji]() for emoticons.
- [Bibata Modern Ice]() cursor theme.

<!-- - [Libre Baskerville]() Serif font, for paragraphs… -->
<!-- - [FiraCode]() `Nerd Font` Mono font, for code, terminal… -->

I also am a big fan of [direnv](https://direnv.net) along Nix Flake’s dev shells
to manage all my development environments declaratively, and activate them
effortlessly with my [dev](./home/module/shell/script/dev-env) script.

## Conventions of this repository

- Files and directories names are `kebab-case` and singular
- `system` contains (NixOS) configurations related to specific devices (hosts)
  - Systems are named after a mythological entity
  - The `module` subdirectory contains Nix modules
- `home` contains (Home-Manager) configuratons related to users’ homes
  - Users usernames are their initials
  - The `module` subdirectory contains Nix modules

## NixOS’ setup instructions

### _0._ Build the installer image

Build a custom live NixOS ISO image from this flake with `nix build` (default).

Boot it from a bootable USB stick (preferably a multi-ISO one like with Ventoy).

It should contain a `cfg` installation helper script that among other niceties
brings you to this current flake copied in `/etc/flake`.

### _1._ Partition, encrypt, format disks

If the choosen file system doesn’t support its own encryption, use
`cryptsetup luksFormat /dev/…` to create an encrypted partition and
`cryptsetup open /dev/… cryptroot` open (decrypt) it.

Partition the disks (and label them), like `fdisk /dev/mapper/cryptroot` or
`cfdisk /dev/mapper/cryptroot` for the LUKS encrypted partition.

Format the partitions, like `mkfs.fat -F 32 /dev/… -n ESP` for the `/boot` one.

Consider creating and mountig **subvolumes** with file system specific commands
and creating and setting a swap partition.

### _2._ Handle hardware configuration

Run the command `nixos-generate-config --root /mnt --dir .` to create a hardware
config in the working directory. Then, compare with choosen system hardware
configuration and fix it if needed.

Set partitions UUIDs after obtaining them with `lsblk -o NAME,SIZE,UUID,LABEL`.

### _3._ Install from the Nix Flake

<!-- TODO parametric Flake path (/etc/flake) -->

Use the command `nixos-install -v --root /mnt --flake '/etc/flake#HOST'` to
install the `HOST` specific NixOS System from this Flake.

Then user home(s) can be installed with
`home-manager switch --flake /etc/flake#USER@HOST`, and the system can be
updated with my custom helper tool located at `home/shell/configure.sh` and
mapped to the command `cfg` (`cfg h` to display usage).

### _5._ Set up Secure Boot

Create Secure Boot keys with `sudo sbctl create-keys`, keeping them in the
default `/var/lib/sbctl` place.

Import the Secure Boot module into the system configuration by adding
`system/module/secureboot.nix` to system `imports = [ ]`, then rebuild the
system with this new configuration.

Check if the machine is ready for Secure Boot enforcement with `sbctl verify`,
if not (which should be the case if you are here, the system booted) reboot to
the UEFI Setup, remove existing keys (Reset to Setup, Erase all Settings…), and
make sure Secure Boot is enabled.

Finally, enforce Secure Boot with `sudo sbctl enroll-keys`, then reboot (and
definitevely enable Secure Boot in UEFI if needed). You can now check if Secure
Boot is properly enabled with `bootctl status`.

## Other configuration repositories

Some other git repositories constitute configuration elements, but are not
directly included in this flake:

- My Nix flakes (development)
  [environments templates](https://github.com/gfauredev/dev-templates)
  - Used with the command `dev <stack>` (defined in `home/module/shell`)
- My [Typst library](https://gitlab.com/gfauredev/typst-lib)
  - Cloned at `$XDG_DATA_HOME/typst/packages/local`

Additionnally, I use a flake in a private repository for private configuration.
It takes this (public) flake as input and extend it where private configuration
is needed, as depicted for example in `private/`.

## Documentation and learning ressources

- [NixOS documentation](https://nixos.org/manual/nixos/unstable)
- [Home Manager documentation](https://nix-community.github.io/home-manager)
- [Home Manager options](https://nix-community.github.io/home-manager/options.html)
- [The Nix Way Dev Templates](https://github.com/the-nix-way/dev-templates)
- [NixOS Wiki](https://nixos.wiki)
- [Nix.dev](https://nix.dev)
- [Vimjoyer YouTube channel](https://www.youtube.com/@vimjoyer)
- [Global Nix options search engine](https://searchix.alanpearce.eu/all/search)
- [NixOS and Flakes](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-configuration-explained)
- [NixOS starter flake configs](https://github.com/Misterio77/nix-starter-configs)
- [Hlissner’s config](https://github.com/hlissner/dotfiles)
- [Gvolpe’s flake article](https://gvolpe.com/blog/private-flake)
- [Yelite’s cfg article](https://greenfield.blog/posts/private-nix-flake-with-public-subtree)
- [Mitchellh’s config](https://github.com/mitchellh/nixos-config)
