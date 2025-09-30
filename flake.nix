{
  description = "Guilhem Fauré’s NixOS and Home-manager Configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05"; # NixOS Stable
    unstablepkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Follow NixOS Stable
    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure Boot
    hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware Configs
    # impermanence.url = "github:nix-community/impermanence"; # Amnesiac root
    # musnix.url = "github:musnix/musnix"; # Music production, audio perf
    stylix.url = "github:danth/stylix/release-25.05"; # Color themes & fonts
    stylix.inputs.nixpkgs.follows = "nixpkgs"; # Follow NixOS Stable
  };
  outputs =
    {
      self,
      nixpkgs,
      unstablepkgs,
      home-manager,
      lanzaboote,
      hardware,
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
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
            pkgs-unstable = import unstablepkgs { inherit system; };
          }
        );
      lib = nixpkgs.lib;
      hm-lib = home-manager.lib;
    in
    {
      # NixOS config, enable: `nixos-rebuild --flake .#hostname` as root
      nixosConfigurations = {
        # Laptop: Griffin, a powerful flying creature
        griffin = lib.nixosSystem {
          # specialArgs = { inherit unstablepkgs; };
          modules = [
            ./system/griffin.nix
            lanzaboote.nixosModules.lanzaboote # Secure boot
            hardware.nixosModules.framework-12th-gen-intel # The laptop
          ];
        };
        # Laptop: Chimera, a flying creature
        chimera = lib.nixosSystem {
          modules = [ ./system/chimera.nix ];
        };
        # Desktop: Muses, goddess of arts and music
        # muses = lib.nixosSystem {
        #   modules = [ ./system/desktop/muses.nix ];
        # };
        # Server: Cerberus, a powerful creature with multiple heads
        # cerberus = lib.nixosSystem {
        #   modules = [ ./system/server/cerberus.nix ];
        # };
        # NixOS live (install) ISO image, build with `nix build` thanks to defaultPackage
        live = lib.nixosSystem {
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./system/live.nix
          ];
        };
      };
      defaultPackage.x86_64-linux = self.nixosConfigurations.live.config.system.build.isoImage;
      # home-manager config, enable: `home-manager --flake .#username@hostname`
      homeConfigurations = {
        "gf@griffin" = hm-lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          extraSpecialArgs.pkgs-unstable = import unstablepkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          modules = [
            ./home/griffin.nix
            ./overlay
            stylix.homeModules.stylix # Colors & Fonts
          ];
        };
        "gf@chimera" = hm-lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home/chimera.nix
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
              pkgs.home-manager # FIXME Not nixpkgs’ version
              # lorri # Your project's nix-env, to test
              pkgs-unstable.nixd # "Official" Nix LSP
              # nil # Nix LSP
              # niv # Easy dependency management, to test
              pkgs-unstable.nixfmt # Formatter
              pkgs-unstable.nixfmt-tree # Format a whole directory of nix files
              # statix # Lints & suggestions for Nix, to test
              nls # Nickel LSP
              yaml-language-server # YAML LSP
              taplo # TOML LSP
              bash-language-server # Bash, shell script LSP
              sbctl # SecureBoot key manager, used for install with Lanzaboote
              shellcheck # Shell script analysis
              # shfmt # Shell script formater # Bash LSP instead
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
