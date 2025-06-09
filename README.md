---
lang: en
---

# My NixOS Flake systems and homes configurations

I use **NixOS** because it allows me to have a system tailored to my needs and
expectations. I’m highly demandant on ergonomics, so I use a lot of tools that
make interacting with the computer more efficient and comfortable. Having to use
the mouse is a chore, so I live mostly in the terminal and in keyboard-driven
apps.

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

- [Starship](https://starship.rs) prompt to always know where you are and other
  useful status information using the shell.
- [Broot](https://dystroy.org/broot) fast and ergonomic file fuzzy-finder.
- [Zoxide](https://github.com/ajeetdsouza/zoxide) smater, faster cd alternative.
- [bat](https://github.com/sharkdp/bat) to display text files neatly.
- [Atuin](https://atuin.sh) cross-terminal and cross-devices command history.
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
[Himalaya](https://github.com/pimalaya/himalaya) and
[Khal](https://github.com/pimutils/khal).

[Stylix](https://stylix.danth.me) Flake to enforce my favorite color theme, my
favorite fonts and other style settings everywhere. To fully leverage OLED
screens for power saving, I always set background to pitch black `#000000`.

- [Catppuccin Mocha](https://catppuccin.com) colorscheme, with black background.
- [Libertinus Serif]() Serif font, for paragraphs…
  - [Libre Baskerville]() Second serif font, for paragraphs…
- [New Computer Modern]() Sans font, for titles, slides…
  - [Nacelle]() Second sans font, for titles, slides…
- [JetBrainsMono]() `Nerd Font` Mono font, for code, terminal…
  - [FiraCode]() Second `Nerd Font` Mono font, for code, terminal…
- [Noto Color Emoji]() for emoticons.
- [Bibata Modern Ice]() cursor theme.

I also am a big fan of [direnv](https://direnv.net) along Nix Flake’s dev shells
to manage all my development environments declaratively, and activate them
effortlessly.

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
`nix build .#nixosConfigurations.live.config.system.build.isoImage`.

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

## Other configuration repositories

Some other git repositories constitute configuration elements, but are not
directly included in this flake:

- My [Typst library](https://gitlab.com/gfauredev/typst-lib)
  - Cloned at `$XDG_DATA_HOME/typst/packages/local`
- My [dev environment templates](https://github.com/gfauredev/dev-templates)
  - Usually cloned at `$XDG_CONFIG_HOME/dev-templates`
  - Used with the alias `dev <stack>`

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
