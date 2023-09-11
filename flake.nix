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

  outputs = { self, nixpkgs, home-manager }:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # NixOS config, available through 'nixos-rebuild --flake .#hostname'
      nixosConfigurations = {
        ninja = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./system/ninja.nix # Light & quick laptop : ninja
            ./system/laptop.nix
            ./system/wireless.nix
            ./system/remaps.nix
            ./system/wayland.nix
          ];
        };
        knight = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./system/knight.nix # Heavy & strong desktop : knight
            ./system/wireless.nix
            ./system/remaps.nix
            ./system/xorg.nix
          ];
        };
        knight = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./system/hydra.nix # Multi-purpose hypervisor : hydra
            ./system/hypervisor.nix
          ];
        };
      };

      # home-manager config, available through 'home-manager --flake .#username@hostname'
      # homeConfigurations = {
      #   "gf@ninja" = home-manager.lib.homeManagerConfiguration {
      #     pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      #     system = "x86_64-linux";
      #     modules = [ ./user/gf.nix ];
      #   };
      # };
    };
}
