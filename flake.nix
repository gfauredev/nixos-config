{
  description = "Guilhem Fauré’s NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    # unstable.url = "github:nixos/nixpkgs/f6950e6"; # Commit before 25.05 Unstable
    # stable.url = "github:nixos/nixpkgs/nixos-25.05"; # 25.05 NixOS Stable
    stable.url = "github:nixos/nixpkgs/nixos-24.11"; # 24.11 NixOS Stable
    # stable.url = "github:nixos/nixpkgs/nixos-24.05"; # 24.05 NixOS Stable

    home-manager = {
      url = "github:nix-community/home-manager"; # Home manager
      inputs.nixpkgs.follows = "nixpkgs"; # Follow nixpkgs
    };

    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure boot
    sops-nix.url = "github:Mic92/sops-nix"; # Manage secrets

    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware
    musnix.url = "github:musnix/musnix"; # Music production, audio optimizations
  };

  outputs = { self, nixpkgs, stable, ... }@inputs: {
    nixosModules = {
      # Laptops #
      griffin = { # Griffin, a powerful and flying creature
        imports = [
          ./system/pc/laptop/griffin
          ./system/user/gf.nix # TODO make it an option
          ./system/virtualization.nix # TODO make it an option
          ./system/pc/gaming.nix # TODO make it an option
        ];
      };
      chimera = { # Chimera, a flying creature
        imports = [ ./system/pc/laptop/chimera ];
      };
      # Servers #
      cerberus = { # Cerberus, a powerful creature with multiple heads
        imports = [ ./system/server/cerberus ];
      };
      # Misc #
      overlay = { # Changes made to nixpkgs globally
        imports = [ (import ./overlay) ];
      };
    };
    # NixOS config, available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      # Laptops #
      griffin = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # PC architecture
        specialArgs = { inherit inputs stable; };
        modules = [ self.nixosModules.griffin self.nixosModules.overlay ];
      };
      chimera = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # PC architecture
        specialArgs = { inherit inputs; };
        modules = [ self.nixosModules.chimera self.nixosModules.overlay ];
      };
      # Servers #
      cerberus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Server architecture
        specialArgs = { inherit inputs; };
        modules = [ self.nixosModules.cerberus self.nixosModules.overlay ];
      };
      # NixOS live (install) ISO image #
      installer = nixpkgs.lib.nixosSystem { # TODO this cleaner
        system = "x86_64-linux"; # System architecture
        # Build : nix build .#nixosConfigurations.installer.config.system.build.isoImage
        specialArgs = { inherit inputs; };
        modules = [
          # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
          ./system/installer.nix # Bootable ISO used to install NixOS
        ];
      };
    };

    # home-manager config, available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      "gf@griffin" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # TODO factorize
        extraSpecialArgs = {
          inherit inputs;
          stablepkgs = import inputs.stable { # TODO do this cleaner
            system = "x86_64-linux"; # System architecture TODO factorize
            config.allowUnfree = true;
          };
        };
        modules = [ # TODO clean this down to one module
          ./home/gf.nix # Myself’s home
          ./home/wayland/griffin.nix # Griffin’s GUI
          ./home/tool # Tooling, mostly technical
          ./home/media # Media consuming and editing
          (import ./overlay)
        ];
      };
      "gf@chimera" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # TODO factorize
        extraSpecialArgs = { inherit inputs stable; };
        modules = [ # TODO clean this down to one module
          ./home/gf.nix # Myself’s home
          ./home/wayland/griffin.nix # Griffin’s GUI
        ];
      };
    };
  };
}
