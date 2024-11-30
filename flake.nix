{
  description = "Guilhem Fauré’s NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    # pkgs25-04.url = "github:nixos/nixpkgs/f6950e6"; # Commit before 25.05 Unstable
    # pkgs25-05.url = "github:nixos/nixpkgs/nixos-25.05"; # 25.05 NixOS Stable
    pkgs24-11.url = "github:nixos/nixpkgs/nixos-24.11"; # 24.11 NixOS Stable
    # pkgs24-05.url = "github:nixos/nixpkgs/nixos-24.05"; # 24.05 NixOS Stable

    home-manager = {
      url = "github:nix-community/home-manager"; # Home manager
      inputs.nixpkgs.follows = "nixpkgs"; # Follow nixpkgs
    };

    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure boot
    sops-nix.url = "github:Mic92/sops-nix"; # Manage secrets

    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware
    musnix.url = "github:musnix/musnix"; # Music production, audio optimizations
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosModules = {
      # Laptops #
      griffin = { # Griffin, a powerful and flying creature
        imports = [
          ./system/pc/laptop/griffin # TODO use below options instead
          ./system/user/gf.nix # TODO make it an option of module system/user/
          ./system/virtualization.nix # TODO make it an option of module system/
          ./system/pc/gaming.nix # TODO make it an option of module system/pc/
          (import ./overlay) # Changes made to nixpkgs globally TODO factorize
        ];
      };
      chimera = { # Chimera, a flying creature
        imports = [ ./system/pc/laptop/chimera ];
      };
      # Servers #
      cerberus = { # Cerberus, a powerful creature with multiple heads
        imports = [ ./system/server/cerberus ];
      };
    };
    # NixOS config, available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      # Laptops #
      griffin = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # PC architecture
        specialArgs = { inherit inputs; };
        modules = [ self.nixosModules.griffin ];
      };
      chimera = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # PC architecture
        specialArgs = { inherit inputs; };
        modules = [ self.nixosModules.chimera ];
      };
      # Servers #
      cerberus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Server architecture
        specialArgs = { inherit inputs; };
        modules = [ self.nixosModules.cerberus ];
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

    homeModules = {
      "gf@griffin" = {
        imports = [
          ./home/gf.nix # Myself, main user
          ./home/wayland/griffin.nix # Griffin laptop’s GUI
          ./home/tool # Miscellaneous tools, mostly technical
          ./home/media # Media consuming and editing
          (import ./overlay) # Changes made to nixpkgs globally TODO factorize
        ];
      };
      "gf@chimera" = {
        imports = [
          ./home/gf.nix # Myself, main user
          ./home/wayland # Laptop GUI
          ./home/tool # Miscellaneous tools, mostly technical
          ./home/media # Media consuming and editing
          (import ./overlay) # Changes made to nixpkgs globally TODO factorize
        ];
      };
    };
    # home-manager config, available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      "gf@griffin" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs;
          stablepkgs = import inputs.pkgs24-11 { # TODO do this cleaner
            system = "x86_64-linux"; # System architecture TODO factorize
            config.allowUnfree = true;
          };
        };
        modules = [ self.homeModules."gf@griffin" ];
      };
      "gf@chimera" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ self.homeModules."gf@chimera" ];
      };
    };
  };
}
