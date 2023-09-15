{
  description = "Guilhem Fauré’s NixOS Configurations";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05"; # NixOS 23.05

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Misc
    musnix.url = "github:musnix/musnix";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, musnix }@inputs: {
    # NixOS config, available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      ninja = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.framework-12th-gen-intel
          musnix.nixosModules.musnix # System improvements for audio
          ./system/default.nix
          ./system/multilingual.nix
          ./system/ninja.nix # Light & quick laptop : ninja
          ./system/gf.nix # Main user
          ./system/laptop.nix
          # ./system/realtime.nix # TODO adapt for laptops
          ./system/wireless.nix
          ./system/remap.nix
          ./system/print-scan.nix
        ];
      };
      knight = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        system = "x86_64-linux";
        modules = [
          musnix.nixosModules.musnix # System improvements for audio
          ./system/default.nix
          ./system/multilingual.nix
          ./system/knight.nix # Heavy & strong desktop : knight
          ./system/gf.nix # Main user
          ./system/realtime.nix
          ./system/wireless.nix
          ./system/remap.nix
          ./system/xorg.nix
          ./system/print-scan.nix
        ];
      };
      hydra = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        system = "x86_64-linux";
        modules = [
          ./system/default.nix
          ./system/hydra.nix # Multi-purpose hypervisor : hydra
          ./system/hypervisor.nix
        ];
      };
      scout = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        system = "x86_64-linux";
        modules = [
          ./system/default.nix
          ./system/multilingual.nix
          ./system/scout.nix # Light laptop for travel : scout
          ./system/gf.nix # Main user
          ./system/laptop.nix
          ./system/wireless.nix
          ./system/remap.nix
          ./system/print-scan.nix
        ];
      };
      installer = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        system = "x86_64-linux";
        modules = [
          ./system/default.nix
          ./system/installer.nix # NixOS installer
          ./system/wireless.nix
        ];
      };
    };

    # home-manager config, available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      "gf@ninja" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = inputs;
        system = "x86_64-linux";
        modules = [
          ./user/default.nix # Default, like text editor
          ./user/gf.nix # User
          ./user/sway.nix # sway window manager
          ./user/laptop.nix # Laptop related
          # ./user/hard.nix # Hardware creation
          ./user/audio.nix # Audio & Music creation
          # ./user/photo.nix # Photo & Images creation
          ./user/social.nix # Social interaction
          ./user/media.nix # Media consuming
          # ./user/virtualisation.nix
        ];
      };
      "gf@knight" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = inputs;
        system = "x86_64-linux";
        modules = [
          ./user/default.nix # Default, like text editor
          ./user/gf.nix # User
          ./user/i3.nix # i3 window manager
          ./user/hard.nix # Hardware creation
          ./user/audio.nix # Audio & Music creation
          ./user/video.nix # Video & Animation creation
          ./user/photo.nix # Photo & Images creation
          ./user/social.nix # Social interaction
          ./user/media.nix # Media consuming
          ./user/game.nix # Video gaming
          ./user/virtualisation.nix
        ];
      };
    };

    # Used with `nix develop`
    devShells.x86_64-linux = {
      media = pkgs.mkShell { }; # Tools for documents, like pandoc or latex
      lua = pkgs.mkShell { };
      web = pkgs.mkShell { };
      python = pkgs.mkShell { };
      java = pkgs.mkShell { };
      rust = pkgs.mkShell { };
      c = pkgs.mkShell { };
      query = pkgs.mkShell { };
      default = pkgs.mkShell { };
    };
  };
}
