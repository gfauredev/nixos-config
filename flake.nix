{
  description = "Guilhem Fauré’s NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable

    # agenix.url = "github:ryantm/agenix"; # Store secrets encrypted

    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure boot

    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware

    home-manager = {
      url = "github:nix-community/home-manager"; # Home manager
      inputs.nixpkgs.follows = "nixpkgs"; # Follow nixpkgs
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    musnix.url = "github:musnix/musnix"; # Realtime audio
  };

  # outputs = { self, nixpkgs, agenix, lanzaboote, nixos-hardware, home-manager, musnix, ... }@inputs: {
  outputs = { self, nixpkgs, lanzaboote, nixos-hardware, home-manager, musnix, ... }@inputs: {
    # NixOS config, available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      # Laptops
      ninja = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote # Secure boot
          # agenix.nixosModules.default # Secrets storage
          nixos-hardware.nixosModules.framework-12th-gen-intel
          musnix.nixosModules.musnix # System improvements for audio
          ./system # TODO sub modules of defaults auto import default.nix
          ./system/pc # It’s a personal computer, not headless
          ./system/pc/ninja.nix # Light & quick laptop : ninja
          ./system/pc/gf.nix # Main user
          ./system/pc/laptop.nix
          ./system/realtime.nix
          ./system/pc/remap.nix
          ./system/print-scan.nix
          ./system/virtualization.nix
        ];
      };
      scout = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote # Secure boot
          # agenix.nixosModules.default # Secrets storage
          nixos-hardware.nixosModules.common-cpu-intel # Hardware related
          nixos-hardware.nixosModules.common-pc # Hardware related
          nixos-hardware.nixosModules.common-pc-ssd # Hardware related
          ./system # TODO sub modules of defaults auto import default.nix
          ./system/pc # It’s a personal computer, not headless
          ./system/pc/scout.nix # Light laptop for travel : scout
          ./system/pc/gf.nix # Main user
          ./system/pc/laptop.nix
          ./system/pc/remap.nix
          ./system/print-scan.nix
        ];
      };
      # Desktops
      knight = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote # Secure boot
          # agenix.nixosModules.default # Secrets storage
          nixos-hardware.nixosModules.common-cpu-amd # Hardware related
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          nixos-hardware.nixosModules.common-pc # Hardware related
          nixos-hardware.nixosModules.common-pc-ssd # Hardware related
          musnix.nixosModules.musnix # System improvements for audio
          ./system # TODO sub modules of defaults auto import default.nix
          ./system/pc # It’s a personal computer, not headless
          ./system/pc/knight.nix # Heavy & strong desktop : knight
          ./system/pc/gf.nix # Main user
          # ./system/realtime.nix # FIXME conflicts with Nvidia drivers
          ./system/pc/remap.nix
          ./system/pc/xorg.nix
          ./system/print-scan.nix
          ./system/pc/gaming.nix
        ];
      };
      # Servers
      cerberus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote # Secure boot
          # agenix.nixosModules.default # Secrets storage
          nixos-hardware.nixosModules.common-cpu-intel # Hardware related
          nixos-hardware.nixosModules.common-pc # Hardware related
          ./system
          ./system/headless # A server
          ./system/headless/cerberus.nix # Multi-purpose : cerberus
          ./system/virtualization.nix
        ];
      };
      # Misc
      installer = nixpkgs.lib.nixosSystem {
        # Built with : nix build .#nixosConfigurations.installer.config.system.build.isoImage
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          # agenix.nixosModules.default # Secrets storage
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./system
          ./system/installer.nix # Bootable ISO used to install NixOS
        ];
      };
    };

    # home-manager config, available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      "gf@ninja" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit inputs;
          hwmon = "4/temp3_input";
        };
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home # Default, like text editor # TODO auto import default.nix
          ./home/gf # My main user
          ./home/window-manager.nix # wayland common
          ./home/hyprland # Hyprland window manager
          ./home/hyprland/ninja.nix # ninja’s specific Hyprland
          ./home/waybar # wayland bar
          ./home/rofi # wayland launcher
          ./home/hard.nix # Hardware creation
          ./home/audio.nix # Audio & Music creation
          ./home/photo.nix # Photo & Images creation
          ./home/media.nix # Media consuming
          ./home/social.nix # Social interaction
          ./home/i3.nix # XOrg compatibility wm
        ];
      };
      "gf@knight" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit inputs;
          hwmon = "2/temp3_input";
        };
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home # Default, like text editor # TODO auto import default.nix
          ./home/gf # My main user
          ./home/window-manager.nix # wayland common
          ./home/hyprland # Hyprland window manager
          ./home/hyprland/knight.nix # knight’s specific Hyprland
          ./home/waybar # wayland bar
          ./home/waybar/widescreen.nix # wayland bar for wide screens
          # ./home/onagre.nix # wayland launcher
          ./home/rofi # wayland launcher
          ./home/hard.nix # Hardware creation
          ./home/audio.nix # Audio & Music creation
          ./home/video.nix # Video & Animation creation
          ./home/photo.nix # Photo & Images creation
          ./home/social.nix # Social interaction
          ./home/media.nix # Media consuming
          ./home/gaming.nix # Video gaming
          ./home/i3.nix # XOrg compatibility wm
        ];
      };
    };
  };
}
