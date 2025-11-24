{
  description = "Guilhem Fauré’s NixOS and Home-manager Configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05"; # NixOS Stable
    unstablepkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Follow NixOS Stable
    lanzaboote.url = "github:nix-community/lanzaboote/432cca54da42c1974d05a57ea0f3a427753a03f4"; # Secure Boot
    hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware Configs
    # nixpak = {
    #   url = "github:nixpak/nixpak"; # Declarative bubblewrap (sandboxing)
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
      eachSystem =
        f:
        nixpkgs.lib.genAttrs
          [
            # "riscv64-linux" # 64-bit RISC-V Linux
            "aarch64-linux" # 64-bit ARM Linux
            "x86_64-linux" # 64-bit Intel/AMD Linux
          ]
          (
            system:
            f {
              pkgs = import nixpkgs { inherit system; };
              pkgs-unstable = import unstablepkgs { inherit system; };
            }
          );
      system = nixpkgs.lib.nixosSystem;
      home = home-manager.lib.homeManagerConfiguration;
    in
    {
      # NixOS config, enable: `nixos-rebuild --flake .#hostname` as root
      nixosConfigurations = {
        # Laptop: Griffin, a powerful flying creature
        griffin = system {
          # specialArgs = { inherit unstablepkgs; };
          modules = [
            {
              system.stateVersion = "25.05";
              nixpkgs.hostPlatform = "x86_64-linux";
            }
            ./system/griffin.nix
            lanzaboote.nixosModules.lanzaboote # Secure boot
            hardware.nixosModules.framework-12th-gen-intel # The laptop
          ];
        };
        # Laptop: Chimera, a flying creature
        chimera = system {
          modules = [
            {
              system.stateVersion = "25.11";
              nixpkgs.hostPlatform = "x86_64-linux";
            }
            ./system/chimera.nix
          ];
        };
        # Desktop: Muses, goddess of arts and music
        # muses = system {
        #   modules = [
        #     {
        #       system.stateVersion = "25.11";
        #       nixpkgs.hostPlatform = "x86_64-linux";
        #     }
        #     ./system/desktop/muses.nix
        #   ];
        # };
        # Server: Cerberus, a powerful creature with multiple heads
        # cerberus = system {
        #   modules = [
        #     {
        #       system.stateVersion = "25.11";
        #       nixpkgs.hostPlatform = "x86_64-linux";
        #     }
        #     ./system/server/cerberus.nix
        #   ];
        # };
        # NixOS live (install) ISO image, build with `nix build` thanks to defaultPackage
        live = system {
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./system/live.nix
          ];
        };
      };
      defaultPackage.x86_64-linux = self.nixosConfigurations.live.config.system.build.isoImage;
      # home-manager config, enable: `home-manager --flake .#username@hostname`
      homeConfigurations = {
        "gf@griffin" = home {
          pkgs = import nixpkgs {
            system = "x86_64-linux"; # TODO Define it from corresponding system’s hostPlatform
          };
          extraSpecialArgs.pkgs-unstable = import unstablepkgs {
            system = "x86_64-linux"; # TODO Define it from corresponding system’s hostPlatform
            allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "albert" ];
          };
          modules = [
            { home.stateVersion = "25.05"; } # TODO Define it from corresponding system.stateVersion
            ./home/griffin.nix
            stylix.homeModules.stylix # Colors & Fonts
          ];
        };
        "gf@chimera" = home {
          pkgs = import nixpkgs {
            system = "x86_64-linux"; # TODO Define it from corresponding system’s hostPlatform
            # config.allowUnfree = true;
          };
          modules = [
            { home.stateVersion = "25.11"; } # TODO Define it from corresponding system.stateVersion
            ./home/chimera.nix
            stylix.homeModules.stylix # Colors & Fonts
          ];
        };
      };
      # This configuration’s development shell, preferably enabled with direnv
      devShells = eachSystem (
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
