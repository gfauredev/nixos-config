{
  description = "Guilhem Fauré’s NixOS and Home-manager Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    # pkgs25-04.url = "github:nixos/nixpkgs/f6950e6"; # Commit before 25.05 Unstable
    pkgs25-05.url = "github:nixos/nixpkgs/nixos-25.05"; # 25.05 NixOS Stable
    # pkgs24-11.url = "github:nixos/nixpkgs/nixos-24.11"; # 24.11 NixOS Stable
    # pkgs24-05.url = "github:nixos/nixpkgs/nixos-24.05"; # 24.05 NixOS Stable

    home-manager = {
      # Manage home configurations
      url = "github:nix-community/home-manager"; # Home manager
      inputs.nixpkgs.follows = "nixpkgs"; # Follow nixpkgs
    };
    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure boot
    hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware
    # musnix.url = "github:musnix/musnix"; # Music production, audio optim
    stylix.url = "github:danth/stylix"; # Manage color themes and fonts
  };

  outputs =
    {
      self,
      nixpkgs,
      pkgs25-05,
      home-manager,
      lanzaboote,
      hardware,
      stylix,
    }:
    let
      supportedSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "riscv64-linux" # 64-bit RISC-V Linux
      ];
      forEachSupportedSystem =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f { pkgs = import nixpkgs { inherit system; }; });
      users = import ./user; # Common users configurations
    in
    {
      nixosModules.overlay = {
        imports = [
          (import ./overlay) # Changes made to nixpkgs globally
        ];
      };
      # NixOS config, enable: `nixos-rebuild --flake .#hostname`
      nixosConfigurations = {
        # Laptop: Griffin, a powerful flying creature
        griffin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux"; # PC architecture
          # specialArgs = { inherit pkgs25-05; }; # FIXME
          modules = [
            ./system/laptop/griffin
            { users.users.gf = users.gf; }
            self.nixosModules.overlay
            lanzaboote.nixosModules.lanzaboote # Secure boot
            hardware.nixosModules.framework-12th-gen-intel # The laptop
          ];
        };
        # Laptop: Chimera, a flying creature
        chimera = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux"; # PC architecture
          modules = [
            ./system/laptop/chimera
            { users.users.gf = users.gf; }
            self.nixosModules.overlay
            # lanzaboote.nixosModules.lanzaboote # Secure boot
          ];
        };
        # Desktop: Muses, goddess of arts and music
        muses = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux"; # PC architecture
          modules = [
            ./system/desktop/muses
            self.nixosModules.overlay
          ];
        };
        # Server: Cerberus, a powerful creature with multiple heads
        cerberus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux"; # Server architecture
          modules = [
            ./system/server/cerberus
            self.nixosModules.overlay
          ];
        };
        # NixOS live (install) ISO image #
        live = pkgs25-05.lib.nixosSystem {
          # Build: nix build .#nixosConfigurations.live.config.system.build.isoImage
          system = "x86_64-linux"; # Target system architecture
          modules = [
            "${pkgs25-05}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./system/live # Bootable ISO used to install NixOS
            # self.nixosModules.overlay
          ];
        };
      };
      # home-manager config, enable: `home-manager --flake .#username@hostname`
      homeConfigurations = {
        "gf@griffin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            stablepkgs = import pkgs25-05 {
              # TODO do this cleaner, generic
              system = "x86_64-linux"; # System architecture TODO factorize
              config.allowUnfree = true;
            };
            user = users.gf;
          };
          modules = [
            ./home/gf/griffin.nix
            self.nixosModules.overlay
            stylix.homeModules.stylix # Color & fonts
          ];
        };
        "gf@chimera" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            stablepkgs = import pkgs25-05 {
              # TODO do this cleaner, generic
              system = "x86_64-linux"; # System architecture TODO factorize
              config.allowUnfree = true;
            };
            user = users.gf;
          };
          modules = [
            ./home/gf/chimera.nix
            self.nixosModules.overlay
            stylix.homeModules.stylix # Color & fonts
          ];
        };
      };
      # This configuration’s development shell, preferably enabled with direnv
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              cachix # CLI for Nix binary cache
              lorri # To TEST
              nil # Nix LSP
              niv # Dependency management
              nixfmt # Formatter
              nixfmt-tree # Format a whole directory of nix files
              statix # Lints & suggestions for Nix
              vulnix # NixOS vulnerability scanner
              nls # Nickel LSP
              yaml-language-server # YAML LSP
              taplo # TOML LSP
              bash-language-server # Bash, shell script LSP
              shellcheck # Shell script analysis
              shfmt # Shell script formater
              vscode-langservers-extracted # HTML/CSS/JS(ON)
              wev # Evaluate inputs sent to wayland to debug
            ];
            # env = { }; # Environment variable
            # shellHook = ""; # Shell command(s) activated when entering dev env
          };
        }
      );
    };
}
