{
  description = "Guilhem Fauré’s NixOS Configurations";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    unstable-pre-25-05.url = "github:nixos/nixpkgs/f6950e6"; # Pre 25.05 commit
    # stable-25-05.url = "github:nixos/nixpkgs/nixos-25.05"; # Next Stable
    stable-24-11.url = "github:nixos/nixpkgs/nixos-24.11"; # Current Stable
    stable-24-05.url = "github:nixos/nixpkgs/nixos-24.05"; # Previous Stable

    home-manager = {
      url = "github:nix-community/home-manager"; # Home manager
      inputs.nixpkgs.follows = "nixpkgs"; # Follow nixpkgs
    };

    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure boot
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware

    sops-nix.url = "github:Mic92/sops-nix"; # Manage secrets

    musnix.url = "github:musnix/musnix"; # Music production, audio optimizations
  };

  outputs = { unstable, ... }@inputs:
    let
      system = "x86_64-linux"; # PC architecture (may evolve to RISC-V or ARM)
      pkgs = unstable.legacyPackages.${system};
      stablepkgs = inputs.stable-24-11.legacyPackages.${system};
    in {
      # NixOS config, available through 'nixos-rebuild --flake .#hostname'
      nixosConfigurations = {
        # Laptops #
        griffin = unstable.lib.nixosSystem {
          specialArgs = { inherit inputs stablepkgs; };
          modules = [
            ./system/pc/laptop/griffin # Griffin, a powerful and flying creature
            ./system/user/gf.nix # TODO make it an option of systems (may include home)
            ./system/virtualization.nix # TODO make it an option of systems
            ./system/pc/gaming.nix # TODO make it an option of systems
            (import ./overlay)
          ];
        };
        chimera = unstable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./system/pc/laptop/chimera # Chimera, a flying creature
          ];
        };
        # Servers #
        cerberus = unstable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./system/server/cerberus # Cerberus, a powerful creature with multiple heads
            # ./system/virtualization.nix # TODO make it an option of systems
          ];
        };
        # NixOS live (install) ISO image #
        installer = unstable.lib.nixosSystem {
          # Build with : nix build .#nixosConfigurations.installer.config.system.build.isoImage
          specialArgs = { inherit inputs; };
          modules = [
            # "${unstable}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${unstable}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            ./system/installer.nix # Bootable ISO used to install NixOS
          ];
        };
      };

      # home-manager config, available through 'home-manager --flake .#username@hostname'
      homeConfigurations =
        # TODO cleaner common configs (nix functions)
        let
          alacritty = {
            name = "alacritty"; # Name of the terminal (for matching)
            cmd = "alacritty"; # Launch terminal
            exec = "--command"; # Option to execute a command in place of shell
            cd =
              "--working-directory"; # Option to launch terminal in a directory
            # Classed terminals (executes a command)
            monitoring =
              "alacritty --class monitoring --command"; # Monitoring terminal
            note = "alacritty --class note --command"; # Monitoring terminal
            menu =
              "alacritty --option window.opacity=0.7 --class menu --command"; # Menu terminal
          };
          wezterm = {
            name = "wezterm"; # Name of the terminal (for matching)
            cmd = "wezterm start"; # Launch terminal
            # cmd = "wezterm start --always-new-process"; # FIX when too much terms crash
            exec = ""; # Option to execute a command in place of shell
            cd = "--cwd"; # Option to launch terminal in a directory
            # Classed terminals (executes a command)
            monitoring = "wezterm start --class monitoring"; # Monitoring
            note = "wezterm start --class note"; # Note
            menu =
              "wezterm --config window_background_opacity=0.7 start --class menu"; # Menu
          };
          # location = "/config"; # This Flake location, to use in config script
          location = "/home/gf/.config/flake"; # This Flake location
        in {
          "gf@griffin" = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs;
              stablepkgs =
                import inputs.stable-24-11 { # TODO do this cleaner, globally
                  inherit system;
                  config.allowUnfree = true;
                };
              term = wezterm;
              term-alt = alacritty;
              location = location;
            };
            modules = [ # TODO reduce number of imported modules, custom modules
              ./home/gf.nix # Myself’s home
              ./home/wayland/griffin.nix # Griffin’s GUI
              ./home/tool # Tooling, mostly technical
              ./home/media # Media consuming and editing
              (import ./overlay)
            ];
          };
          "gf@chimera" = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs stablepkgs;
              term = alacritty;
              term-alt = wezterm;
              location = location;
            };
            modules = [
              ./home/gf.nix # Myself’s home
              ./home/wayland/griffin.nix # Griffin’s GUI
            ];
          };
        };
    };
}
