{
  description = "Guilhem Fauré’s NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    # unstable.url = "github:nixos/nixpkgs/f6950e6"; # Commit before 25.05 Unstable
    # stable.url = "github:nixos/nixpkgs/nixos-25.05"; # 25.05 NixOS Stable
    stablepkgs.url = "github:nixos/nixpkgs/nixos-24.11"; # 24.11 NixOS Stable
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

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosModules = {
      # Laptops #
      griffin = { # Griffin, a powerful and flying creature
        imports = [
          ./system/pc/laptop/griffin # TODO use below options instead
          ./system/user/gf.nix # TODO make it an option of module system/user/
          ./system/virtualization.nix # TODO make it an option of module system/
          ./system/pc/gaming.nix # TODO make it an option of module system/pc/
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
        specialArgs = { inherit inputs; };
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

    homeModules = {
      gf = { # Myself, main user
        imports = [ ./home/gf.nix ];
      };
      griffin = { # Griffin laptop’s GUI
        imports = [ ./home/wayland/griffin.nix ];
      };
      tool = { # Miscellaneous tools, mostly technical
        imports = [ ./home/tool ];
      };
      media = { # Media consuming and editing
        imports = [ ./home/media ];
      };
    };
    # home-manager config, available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      "gf@griffin" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs;
          stablepkgs = import inputs.stablepkgs { # TODO do this cleaner
            system = "x86_64-linux"; # System architecture TODO factorize
            config.allowUnfree = true;
          };
        };
        modules = [
          self.homeModules.gf
          self.homeModules.griffin
          self.homeModules.tool
          self.homeModules.media
          self.nixosModules.overlay
        ];
      };
      "gf@chimera" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ self.homeModules.gf ];
      };
    };
  };
}
