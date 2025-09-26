{
  description = "Guilhem Fauré’s NixOS and Home-manager Configurations";
  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    nixos2505.url = "github:nixos/nixpkgs/nixos-25.05"; # NixOS Stable (25.05)
    home-manager.url = "github:nix-community/home-manager"; # Home Manager
    home-manager.inputs.nixpkgs.follows = "nixos2505"; # Follows Stable Nixpkgs
    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure Boot
    hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware Configs
    impermanence.url = "github:nix-community/impermanence"; # Temporary root
    # musnix.url = "github:musnix/musnix"; # Music production, audio opti.
    stylix.url = "github:danth/stylix"; # Manage color themes and fonts
  };
  outputs =
    {
      self,
      nixos2505,
      unstable,
      home-manager,
      lanzaboote,
      hardware,
      impermanence,
      stylix,
    }:
    let
      systems = [
        "riscv64-linux" # 64-bit RISC-V Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-linux" # 64-bit Intel/AMD Linux
      ];
      forEachSupportedSystem =
        f:
        nixos2505.lib.genAttrs systems (
          system:
          f {
            pkgs = import nixos2505 { inherit system; };
            pkgs-unstable = import unstable { inherit system; };
          }
        );
      lib = nixos2505.lib;
      hm-lib = home-manager.lib;
      # system = "x86_64-linux"; # PC architecture
      # pkgs = stable.legacyPackages.${system};
    in
    {
      # NixOS config, enable: `nixos-rebuild --flake .#hostname` as root
      nixosConfigurations = {
        # Laptop: Griffin, a powerful flying creature
        griffin = lib.nixosSystem {
          # inherit system;
          # specialArgs = { inherit pkgs-unstable; };
          modules = [
            ./system/laptop/griffin
            lanzaboote.nixosModules.lanzaboote # Secure boot
            hardware.nixosModules.framework-12th-gen-intel # The laptop
            impermanence.nixosModules.impermanence # Temporary root FS
          ];
        };
        # Laptop: Chimera, a flying creature
        chimera = lib.nixosSystem {
          modules = [ ./system/laptop/chimera ];
        };
        # Desktop: Muses, goddess of arts and music
        muses = lib.nixosSystem {
          modules = [ ./system/desktop/muses ];
        };
        # Server: Cerberus, a powerful creature with multiple heads
        cerberus = lib.nixosSystem {
          modules = [ ./system/server/cerberus ];
        };
        # NixOS live (install) ISO image, build with `nix build` thanks to defaultPackage
        live = lib.nixosSystem {
          modules = [
            "${nixos2505}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./system/live.nix
          ];
        };
      };
      defaultPackage.x86_64-linux = self.nixosConfigurations.live.config.system.build.isoImage;
      # home-manager config, enable: `home-manager --flake .#username@hostname`
      homeConfigurations = {
        "gf@griffin" = hm-lib.homeManagerConfiguration {
          pkgs = nixos2505.legacyPackages.x86_64-linux;
          # extraSpecialArgs = { inherit pkgs-unstable; };
          modules = [
            { home.stateVersion = "25.05"; }
            ./home/device/griffin.nix
            stylix.homeModules.stylix # Colors & Fonts
          ];
        };
        "gf@chimera" = hm-lib.homeManagerConfiguration {
          pkgs = nixos2505.legacyPackages.x86_64-linux;
          modules = [
            { home.stateVersion = "25.05"; }
            ./home/device/chimera.nix
            stylix.homeModules.stylix # Colors & Fonts
          ];
        };
      };
      # This configuration’s development shell, preferably enabled with direnv
      devShells = forEachSupportedSystem (
        { pkgs, pkgs-unstable }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # cachix # CLI for Nix binary cache
              # pkgs.home-manager # FIXME Not the same version than pkgs’
              lorri # To TEST
              nil # Nix LSP
              niv # Dependency management
              pkgs-unstable.nixfmt # Formatter
              nixfmt-tree # Format a whole directory of nix files
              statix # Lints & suggestions for Nix
              vulnix # NixOS vulnerability scanner
              nls # Nickel LSP
              yaml-language-server # YAML LSP
              taplo # TOML LSP
              bash-language-server # Bash, shell script LSP
              sbctl # SecureBoot key manager, used for install with Lanzaboote
              shellcheck # Shell script analysis
              shfmt # Shell script formater
              vscode-langservers-extracted # HTML/CSS/JS(ON)
              wev # Evaluate inputs sent to wayland to debug
            ];
            # env = { }; # Environment variable
            # shellHook = ""; # Shell commands activated when entering dev env
          };
        }
      );
    };
}
