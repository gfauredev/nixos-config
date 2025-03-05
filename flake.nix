{
  description = "Guilhem Fauré’s NixOS and Home-manager Configurations";

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

    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware
    # nixos-hardware.url = "github:NixOS/nixos-hardware/b98df1827a48e"; # Hardware
    # musnix.url = "github:musnix/musnix"; # Music production, audio optimizations
    stylix.url = "github:danth/stylix"; # Manage color themes and fonts
  };

  outputs = { self, nixpkgs, pkgs24-11, home-manager, lanzaboote, nixos-hardware
    , stylix }:
    let
      supportedSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems
        (system: f { pkgs = import nixpkgs { inherit system; }; });
    in {
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
            stylix.nixosModules.stylix # Color & fonts TODO for home-manager
          ];
        };
        chimera = { # Chimera, a flying creature
          imports = [ ./system/pc/laptop/chimera ];
        };
        # Desktops #
        # muses = { # Muses, nine goddesses of the arts and sciences
        #   imports = [ ./system/pc/desktop/muses ];
        # };
        # Servers #
        cerberus = { # Cerberus, a powerful creature with multiple heads
          imports = [ ./system/server/cerberus ];
        };
        # NixOS live (install) ISO image #
        live = {
          imports = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            ./system/installer.nix # Bootable ISO used to install NixOS
          ];
        };
        overlay = {
          imports = [
            (import ./overlay) # Changes made to nixpkgs globally
          ];
        };
      };
      # NixOS config, enable: `nixos-rebuild --flake .#hostname`
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
        # Desktops #
        # muses = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux"; # PC architecture
        #   # specialArgs = { inherit inputs; };
        #   modules = [ self.nixosModules.muses self.nixosModules.overlay ];
        # };
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
      # home-manager config, enable: `home-manager --flake .#username@hostname`
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
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            cachix # CLI for Nix binary cache
            lorri # To TEST
            nil # Nix LSP
            niv # Dependency management
            nixfmt # Formater
            statix # Lints & suggestions for Nix
            vulnix # NixOS vulnerability scanner
          ];
          # env = { }; # Environment variable
          # shellHook = ""; # Shell command(s) activated when entering dev env
        };
      });
    };
}
