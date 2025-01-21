{
  description = "Guilhem Fauré’s NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    # pkgs25-04.url = "github:nixos/nixpkgs/f6950e6"; # Commit before 25.05 Unstable
    # pkgs25-05.url = "github:nixos/nixpkgs/nixos-25.05"; # 25.05 NixOS Stable
    pkgs24-11.url = "github:nixos/nixpkgs/nixos-24.11"; # 24.11 NixOS Stable
    # pkgs24-05.url = "github:nixos/nixpkgs/nixos-24.05"; # 24.05 NixOS Stable

    home-manager = { # Manage home configurations
      url = "github:nix-community/home-manager"; # Home manager
      inputs.nixpkgs.follows = "nixpkgs"; # Follow nixpkgs
    };

    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure boot
    # sops-nix.url = "github:Mic92/sops-nix"; # Encrypted secrets management

    # nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/b98df1827a48e"; # Hardware
    # musnix.url = "github:musnix/musnix"; # Music production, audio optimizations
  };

  outputs =
    { self, nixpkgs, pkgs24-11, home-manager, lanzaboote, nixos-hardware }: {
      nixosModules = {
        # Laptops #
        griffin = { # Griffin, a powerful and flying creature
          imports = [
            ./system/pc/laptop/griffin # TODO use below options instead
            ./system/user/gf.nix # TODO make it an option of module system/user/
            ./system/virtualization.nix # TODO make it an option of module system/
            ./system/pc/gaming.nix # TODO make it an option of module system/pc/
            lanzaboote.nixosModules.lanzaboote # TODO factorize, tie to system/default.nix
            nixos-hardware.nixosModules.framework-12th-gen-intel # The laptop
          ];
        };
        chimera = { # Chimera, a flying creature
          imports = [ ./system/pc/laptop/chimera ];
        };
        # Servers #
        cerberus = { # Cerberus, a powerful creature with multiple heads
          imports = [ ./system/server/cerberus ];
        };
        # NixOS live (install) ISO image #
        live = {
          imports = [
            # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            ./system/installer.nix # Bootable ISO used to install NixOS
          ];
        };
        overlay = {
          imports = [
            (import ./overlay) # Changes made to nixpkgs globally
          ];
        };
      };
      # NixOS config, available through 'nixos-rebuild --flake .#hostname'
      nixosConfigurations = {
        # Laptops #
        griffin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux"; # PC architecture
          # specialArgs = { inherit inputs; };
          modules = [ self.nixosModules.griffin self.nixosModules.overlay ];
        };
        chimera = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux"; # PC architecture
          modules = [ self.nixosModules.chimera self.nixosModules.overlay ];
        };
        # Servers #
        cerberus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux"; # Server architecture
          modules = [ self.nixosModules.cerberus self.nixosModules.overlay ];
        };
        # NixOS live (install) ISO image #
        live = nixpkgs.lib.nixosSystem {
          # Build: nix build .#nixosConfigurations.live.config.system.build.isoImage
          system = "x86_64-linux"; # Target system architecture
          modules = [ self.nixosModules.live self.nixosModules.overlay ];
        };
      };

      homeModules = {
        "gf@griffin" = {
          imports = [
            ./home/gf.nix # Myself, main user
            ./home/wayland/griffin.nix # Griffin laptop’s GUI
            ./home/terminal # Terminal emulators
            ./home/editor # CLI and GUI text editors
            ./home/media # Media consuming and editing
          ];
        };
        "gf@chimera" = {
          imports = [
            ./home/gf.nix # Myself, main user
            ./home/wayland # Laptop GUI
            ./home/terminal # Terminal emulators
            ./home/editor # CLI and GUI text editors
            ./home/media # Media consuming and editing
          ];
        };
      };
      # home-manager config, available through 'home-manager --flake .#username@hostname'
      homeConfigurations = {
        "gf@griffin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            stablepkgs = import pkgs24-11 { # TODO do this cleaner
              system = "x86_64-linux"; # System architecture TODO factorize
              config.allowUnfree = true;
            };
          };
          modules = [ self.homeModules."gf@griffin" self.nixosModules.overlay ];
        };
        "gf@chimera" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          # extraSpecialArgs = { inherit inputs; };
          modules = [ self.homeModules."gf@chimera" self.nixosModules.overlay ];
        };
      };
    };
}
