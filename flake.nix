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

  outputs = { self, nixpkgs, home-manager }@inputs: {
    # NixOS config, available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      ninja = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        system = "x86_64-linux";
        modules = [
          ./system/ninja.nix # Light & quick laptop : ninja
          ./system/gf.nix # Main user
          ./system/laptop.nix
          # ./system/realtime.nix
          ./system/wireless.nix
          ./system/remaps.nix
          ./system/wayland.nix
          # ./system/print-scan.nix
        ];
      };
      knight = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        system = "x86_64-linux";
        modules = [
          ./system/knight.nix # Heavy & strong desktop : knight
          ./system/gf.nix # Main user
          # ./system/realtime.nix
          ./system/wireless.nix
          ./system/remaps.nix
          ./system/xorg.nix
          # ./system/wayland.nix
          # ./system/print-scan.nix
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
          ./user/laptop.nix
        ];
      };
      "gf@knight" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = inputs;
        system = "x86_64-linux";
        modules = [
          ./user/gf.nix
        ];
      };
    };
  };
}
