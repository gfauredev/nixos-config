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
          ./system/ninja.nix # Light & quick laptop : ninja
          ./system/gf.nix # Main user
          ./system/laptop.nix
          ./system/realtime.nix
          ./system/wireless.nix
          ./system/remaps.nix
          ./system/wayland.nix
          ./system/print-scan.nix
          ./system/misc.nix
        ];
      };
      knight = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        system = "x86_64-linux";
        modules = [
          musnix.nixosModules.musnix # System improvements for audio
          ./system/knight.nix # Heavy & strong desktop : knight
          ./system/gf.nix # Main user
          ./system/realtime.nix
          ./system/wireless.nix
          ./system/remaps.nix
          ./system/xorg.nix
          # ./system/wayland.nix
          ./system/print-scan.nix
          ./system/misc.nix
        ];
      };
      hydra = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        system = "x86_64-linux";
        modules = [
          ./system/hydra.nix # Multi-purpose hypervisor : hydra
          ./system/hypervisor.nix
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
          ./user/gf.nix
          ./user/gf.laptop.nix
          ./user/gf.tech.nix
          ./user/gf.audio.nix
          ./user/gf.photo.nix
          ./user/gf.social.nix
          ./user/gf.media.nix
          ./user/gf.misc.nix
        ];
      };
      "gf@knight" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = inputs;
        system = "x86_64-linux";
        modules = [
          ./user/gf.nix
          ./user/gf.tech.nix
          ./user/gf.audio.nix
          ./user/gf.video.nix
          ./user/gf.photo.nix
          ./user/gf.social.nix
          ./user/gf.media.nix
          ./user/gf.game.nix
          ./user/gf.misc.nix
        ];
      };
    };
  };
}
