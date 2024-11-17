{
  description = "Guilhem Fauré’s NixOS Configurations";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # NixOS Unstable
    nixpkgs.url =
      "github:nixos/nixpkgs/f6950e6"; # NixOS Unstable just before 25.05
    # stable.url = "github:nixos/nixpkgs/nixos-25.05"; # Next NixOS Stable
    # stable.url = "github:nixos/nixpkgs/nixos-24.11"; # Current NixOS Stable
    stable.url = "github:nixos/nixpkgs/nixos-24.05"; # Previous NixOS Stable

    lanzaboote.url = "github:nix-community/lanzaboote"; # Secure boot
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware

    sops-nix.url = "github:Mic92/sops-nix"; # Manage secrets

    home-manager = {
      url = "github:nix-community/home-manager"; # Home manager
      inputs.nixpkgs.follows = "nixpkgs"; # Follow nixpkgs
    };

    musnix.url = "github:musnix/musnix"; # Music production, audio optimizations

    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # wezterm-flake = {
    #   url = "github:wez/wezterm/main?dir=nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # anyrun = {
    #   url = "github:Kirottu/anyrun";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  # TODO: see if possible to use either @inputs or a comprehensive list of inputs
  outputs = { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux"; # PC architecture (may evolve to RISC-V or ARM)
      pkgs = nixpkgs.legacyPackages.${system};
      stablepkgs = inputs.stable.legacyPackages.${system};
    in {
      # NixOS config, available through 'nixos-rebuild --flake .#hostname'
      nixosConfigurations = {
        ##### Laptops #####
        griffin = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs stablepkgs; };
          modules = [
            ./system/pc/laptop/griffin # Griffin, a powerful and flying creature
            ./system/user/gf.nix # TODO make it an option of systems (may include home)
            ./system/virtualization.nix # TODO make it an option of systems
            ./system/pc/gaming.nix # TODO make it an option of systems
            (import ./overlay)
          ];
        };
        chimera = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./system/pc/laptop/chimera # Chimera, a flying creature
          ];
        };
        ##### Desktops #####
        # typhon = nixpkgs.lib.nixosSystem {
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     ./system/pc/typhon # Typhon, the most powerful creature
        #   ];
        # };
        # work = nixpkgs.lib.nixosSystem {
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     ./system/pc/work # PC used at work
        #   ];
        # };
        ##### Servers #####
        cerberus = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./system/server/cerberus # Cerberus, a powerful creature with multiple heads
            # ./system/virtualization.nix # TODO make it an option of systems
          ];
        };
        ##### NixOS live ISO image, suitable for installation #####
        installer = nixpkgs.lib.nixosSystem {
          # Build with : nix build .#nixosConfigurations.installer.config.system.build.isoImage
          specialArgs = { inherit inputs; };
          modules = [
            # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            ./system/installer.nix # Bootable ISO used to install NixOS
          ];
        };
      };

      # home-manager config, available through 'home-manager --flake .#username@hostname'
      homeConfigurations =
        # TODO cleaner terminal commands (nix functions)
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
            # cmd = "wezterm start --always-new-process"; # FIX when too much temrs crash
            exec = ""; # Option to execute a command in place of shell
            cd = "--cwd"; # Option to launch terminal in a directory
            # Classed terminals (executes a command)
            monitoring = "wezterm start --class monitoring"; # Monitoring
            note = "wezterm start --class note"; # Note
            menu =
              "wezterm --config window_background_opacity=0.7 start --class menu"; # Menu
          };
          location = "/config"; # This Flake location, to use in config script
        in {
          "gf@griffin" = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs stablepkgs;
              term = wezterm;
              term-alt = alacritty;
              location = location;
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
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs stablepkgs;
              term = alacritty;
              term-alt = wezterm;
              location = location;
            };
            modules = [ # TODO clean this down to one module
              ./home/gf.nix # Myself’s home
              ./home/wayland/griffin.nix # Griffin’s GUI
              # ./home/tool # Tooling, mostly technical
              # ./home/media # Media consuming and editing
            ];
          };
          # "gf@typhon" = inputs.home-manager.lib.homeManagerConfiguration {
          #   extraSpecialArgs = {
          #     inherit inputs;
          #     term = alacritty;
          #     term-alt = wezterm;
          #     location = location;
          #   };
          #   modules = [
          #     ./home/gf.nix # Myself’s home
          #     ./home/wayland/typhon.nix # Typhon’s GUI
          #     ./home/tool # Tooling, mostly technical
          #     ./home/media # Media consuming and editing
          #   ];
          # };
          # "gf@work" = inputs.home-manager.lib.homeManagerConfiguration {
          #   extraSpecialArgs = {
          #     inherit inputs;
          #     term = alacritty;
          #     term-alt = wezterm;
          #     location = location;
          #   };
          #   modules = [
          #     ./home/gf.nix # Myself’s home
          #     ./home/wayland # Wayland WM & related
          #     ./home/tool # Tooling, mostly technical
          #     ./home/media # Media consuming and editing
          #   ];
          # };
        };
    };
}
